import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/wallet/network/ton/transaction/controllers/provider.dart';
import 'package:on_chain_wallet/future/wallet/network/ton/transaction/types/types.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';

mixin TonTransactionFeeController on TonTransactionApiController {
  final Cancelable _cancelable = Cancelable();
  WalletTonNetwork get network;
  final _lock = SynchronizedLock();

  late final TonTransactionFeeData txFee = TonTransactionFeeData(
      select: TonTransactionFee.init(network.token), feeToken: network.token);

  void setDefaultFee({String? error}) {
    txFee.setFee(TonTransactionFee.init(network.token, error: error));
  }

  Future<TonSimulateTransaction> simulateTransaction();

  Future<TonTransactionFee> simulateFee() async {
    final transaction = await simulateTransaction();
    final estimate = await client.getTransactionFee(
        address: transaction.address.networkAddress,
        message: transaction.message,
        network: network);
    final success =
        estimate.success && estimate.internalMessages.every((e) => e.success);
    String? result;
    if (!success) {
      result = estimate.resultDescription ??
          estimate.internalMessages
              .firstWhereOrNull(
                  (e) => !e.success && e.resultDescription != null)
              ?.resultDescription;
    }
    return TonTransactionFee(
        storageFee: estimate.storageFee,
        gasFee: estimate.gasFee,
        resultDescription: result,
        actionPhase: estimate.actionPhase,
        fee: estimate.fee,
        isEstimated: estimate.isEstimated,
        success: success);
  }

  Future<void> estimateFee() async {
    _cancelable.cancel();
    await _lock.synchronized(() async {
      txFee.setPending();
      final fee = await MethodUtils.call(() async => await simulateFee());
      if (fee.isCancel) return;
      if (fee.hasError) {
        setDefaultFee(error: fee.localizationError);
        return;
      }
      txFee.setFee(fee.result);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cancelable.cancel();
    txFee.dispose();
  }
}
