import 'package:monero_dart/monero_dart.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/requets/messages/non_encrypted/requests/monero_build_fake_tx.dart';
import 'package:on_chain_wallet/future/wallet/network/monero/transaction/controllers/provider.dart';
import 'package:on_chain_wallet/future/wallet/network/monero/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/transaction.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';

mixin MoneroTransactionFeeController on MoneroTransactionApiController {
  final Cancelable _cancelable = Cancelable();
  final _lock = SynchronizedLock();

  late final MoneroTransactionFeeData txFee = MoneroTransactionFeeData(
      select: MoneroTransactionFee(
          fee: IntegerBalance.zero(network.token), type: TxFeeTypes.normal),
      feeToken: network.token);

  void setFees(
      {required BigInt weight, required DaemonGetEstimateFeeResponse baseFee}) {
    List<BigInt> feesAmount = [];
    const feeTypes = [
      MoneroFeePrority.defaultPriority,
      MoneroFeePrority.low,
      MoneroFeePrority.high
    ];
    for (final i in feeTypes) {
      feesAmount.add(i.calcuateFee(weight: weight, baseFee: baseFee));
    }
    feesAmount.sort((a, b) => a.compareTo(b));
    List<MoneroTransactionFee> fees = List.generate(feeTypes.length, (index) {
      final fee = feesAmount[index];
      return MoneroTransactionFee(
          type: switch (index) {
            0 => TxFeeTypes.slow,
            1 => TxFeeTypes.normal,
            _ => TxFeeTypes.high
          },
          fee: IntegerBalance.token(fee, network.token));
    });
    txFee.setDefaultFees(fees);
  }

  void setDefaultFee({String? error}) {
    final defaultFee = MoneroTransactionFee(
      error: error,
      fee: IntegerBalance.zero(network.token),
      type: TxFeeTypes.normal,
    );

    txFee.setDefaultFees([defaultFee]);
  }

  Future<IMoneroTransactionData> simulateTransaction();

  Future<(BigInt, DaemonGetEstimateFeeResponse)> simulateFee() async {
    final baseFee = await getFeeEstimate();
    final transaction = await simulateTransaction();
    final destinations = transaction.destinations;
    final fakePayments = transaction.payments
        .map((e) => e.paymet.toUnlockedFakePayment())
        .toList();

    final weight = await walletProvider.wallet.nonEncryptedRequest(
      NoneEncryptedRequestFakeMoneroTx(
          destinations: destinations
              .map((e) => MoneroTxDestination(
                  amount: e.amount.balance,
                  address: e.recipient.networkAddress))
              .toList(),
          fee: txFee.fee.fee.balance,
          change: transaction.change,
          fakePayments: fakePayments),
    );
    return (weight + MoneroConst.extraTxWeight, baseFee);
  }

  Future<void> estimateFee() async {
    _cancelable.cancel();
    await _lock.synchronized(() async {
      txFee.setPending();
      final weight = await MethodUtils.call(() async => await simulateFee());
      if (weight.isCancel) return;
      if (weight.hasError) {
        setDefaultFee(error: weight.localizationError);
        return;
      }
      setFees(weight: weight.result.$1, baseFee: weight.result.$2);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cancelable.cancel();
    txFee.dispose();
  }
}
