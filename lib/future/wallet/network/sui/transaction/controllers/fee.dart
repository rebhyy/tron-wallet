import 'package:on_chain/sui/src/transaction/const/constant.dart';
import 'package:on_chain/sui/src/transaction/types/types.dart';
import 'package:on_chain_wallet/app/synchronized/basic_lock.dart';
import 'package:on_chain_wallet/app/utils/method/utiils.dart';
import 'package:on_chain_wallet/future/wallet/network/sui/transaction/types/types.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';
import 'provider.dart';

mixin SuiTransactionFeeController on SuiTransactionApiController {
  final Cancelable _cancelable = Cancelable();
  final _lock = SynchronizedLock();
  WalletSuiNetwork get network;

  late final SuiTransactionFeeData txFee = SuiTransactionFeeData(
      select: SuiTransactionFee(gasPrice: BigInt.zero, feeToken: network.token),
      feeToken: network.token);

  Future<SuiTransactionDataV1> simulateTransaction(
      {required BigInt gasPrice, required BigInt budget});

  void setDefaultFee({String? error}) {
    txFee.setFee(SuiTransactionFee(
        gasPrice: BigInt.zero, feeToken: network.token, error: error));
  }

  Future<SuiTransactionFee> simulateFee() async {
    final gasPrice = await getGasPrice();
    final transaction = await simulateTransaction(
        gasPrice: gasPrice, budget: SuiTransactionConst.maxGas);
    final simulate = await client.simulateGasUsed(transaction);

    return SuiTransactionFee(
        gasPrice: gasPrice, gasUsed: simulate, feeToken: network.token);
  }

  Future<void> estimateFee() async {
    _cancelable.cancel();
    await _lock.synchronized(() async {
      setDefaultFee();
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
