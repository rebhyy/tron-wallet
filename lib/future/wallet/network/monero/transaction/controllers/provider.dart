import 'package:blockchain_utils/utils/binary/utils.dart';
import 'package:blockchain_utils/utils/numbers/utils/int_utils.dart';
import 'package:monero_dart/monero_dart.dart';
import 'package:on_chain_wallet/app/error/exception/app_exception.dart';
import 'package:on_chain_wallet/app/live_listener/live.dart';
import 'package:on_chain_wallet/crypto/requets/messages/non_encrypted/requests/monero_generate_ring_output.dart';
import 'package:on_chain_wallet/future/wallet/controller/controller.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';

mixin MoneroTransactionApiController on DisposableMixin {
  MoneroClient get client;
  WalletProvider get walletProvider;
  WalletMoneroNetwork get network;

  late final CachedObject<DaemonGetEstimateFeeResponse> _estimateFee =
      CachedObject(
          interval: Duration(seconds: network.coinParam.averageBlockTime));

  Future<MoneroRingOutput> buildRingOutput(
      List<MoneroLockedPayment> payments) async {
    BigInt maxGlobalIndex = BigInt.zero;
    for (final i in payments) {
      final globalIndex = i.globalIndex;
      if (globalIndex > maxGlobalIndex) {
        maxGlobalIndex = globalIndex;
      }
    }
    final rctBinary = await client.getBinaryAbsoluteDistribution();
    return await walletProvider.wallet.nonEncryptedRequest(
        NoneEncryptedRequestGenerateRingOutput(
            rctOffsetData: rctBinary,
            payments: payments,
            maxGlobalIndex: maxGlobalIndex,
            fakeOutsLength: MoneroConst.ringSize - 1));
  }

  Future<List<SpendablePayment<T>>>
      generatePaymentOutputsRings<T extends MoneroPayment>(
          {required List<T> payments,
          int fakeOutsLength = 15,
          required List<BigInt> outKeysRequestOrder,
          required List<BigInt> outKeysRequests}) async {
    if (fakeOutsLength <= 0) {
      throw const AppException(
          "fake outs length should be greather than zero.");
    }
    final List<List<OutsEntery>> outs = [];
    final int baseRequestCount = ((fakeOutsLength + 1) * 1.5 + 1).ceil();
    final List<OutKeyResponse> outKeysResponse = [];
    int offset = 0;
    while (offset < outKeysRequests.length) {
      const int size = 1000;
      final int outChunSize =
          IntUtils.min(outKeysRequests.length - offset, size);
      final List<DaemonGetOutRequestParams> chunkRequest = List.generate(
          outChunSize,
          (i) => DaemonGetOutRequestParams(
              amount: BigInt.zero, index: outKeysRequests[offset + i]));
      offset += size;
      final outs = await client.getOuts(chunkRequest);
      outKeysResponse.addAll(outs.outs);
    }
    int base = 0;
    for (final payment in payments) {
      const defaultOutCount =
          MoneroNetworkConst.cryptonoteMinedMoneyUnlockWindow -
              MoneroNetworkConst.cryptonoteDefaultTxSpendableAge;
      final int outputsCount = baseRequestCount + defaultOutCount;
      final List<OutsEntery> out = [];
      final mask = RCT.commitVar(
          xmrAmount: payment.output.amount, mask: payment.output.mask);
      bool hasRealOut = false;
      for (int n = 0; n < outputsCount; ++n) {
        final int i = base + n;
        if (outKeysRequests[i] == payment.globalIndex) {
          if (BytesUtils.bytesEqual(
              outKeysResponse[i].key, payment.output.outputPublicKey)) {
            if (BytesUtils.bytesEqual(outKeysResponse[i].mask, mask)) {
              if (outKeysResponse[i].unlocked) {
                hasRealOut = true;
              }
            }
          }
        }
      }
      if (!hasRealOut) {
        throw const AppException(
            "Daemon response did not include the requested real output");
      }
      out.add(OutsEntery(
          index: payment.globalIndex,
          key: CtKey(dest: payment.output.outputPublicKey, mask: mask)));

      for (int idx = base;
          idx < base + outputsCount && out.length < fakeOutsLength + 1;
          ++idx) {
        final attemptedOutput = outKeysRequestOrder[idx];
        int i;
        for (i = base; i < base + outputsCount; ++i) {
          if (outKeysRequests[i] == attemptedOutput) {
            break;
          }
        }
        if (i == base + outputsCount) {
          throw const AppException(
              "Could not find index of picked output in requested outputs");
        }
        final fakeOutResponse = outKeysResponse[i];
        final fakeOutRequest = outKeysRequests[i];
        final fakeEntry = OutsEntery(
            index: fakeOutRequest,
            key: CtKey(dest: fakeOutResponse.key, mask: fakeOutResponse.mask));
        if (fakeOutResponse.unlocked &&
            fakeOutRequest != payment.globalIndex &&
            !out.contains(fakeEntry)) {
          out.add(fakeEntry);
        }
      }
      out.sort((a, b) => a.index.compareTo(b.index));
      outs.add(out);
      if (out.length < fakeOutsLength + 1) {
        throw const AppException("not enough outs to mix.");
      }

      base += outputsCount;
    }
    return List.generate(payments.length, (i) {
      final payment = payments[i];
      final sourceOuts = outs[i];
      final index =
          sourceOuts.indexWhere((e) => e.index == payment.globalIndex);
      if (index.isNegative) {
        throw const AppException("Index not found.");
      }
      return SpendablePayment<T>(
          payment: payment, outs: sourceOuts, realOutIndex: index);
    });
  }

  Future<DaemonGetEstimateFeeResponse> getFeeEstimate() async {
    return _estimateFee.get(onFetch: () async => await client.getFeeEstimate());
  }
}
