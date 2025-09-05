import 'package:on_chain/aptos/src/transaction/constants/const.dart';
import 'package:on_chain/aptos/src/transaction/types/types.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/wallet/network/aptos/transaction/types/types.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';
import 'provider.dart';

mixin AptosTransactionFeeController on AptosTransactionApiController {
  WalletAptosNetwork get network;
  final Cancelable _cancelable = Cancelable();
  final _lock = SynchronizedLock();

  late final AptosTransactionFeeData txFee = AptosTransactionFeeData(
      select: AptosTransactionFee(gasUnitPrice: BigInt.zero, network: network),
      feeToken: network.token);
  void setDefaultFee({String? error}) {
    txFee.setFee(AptosTransactionFee(
        gasUnitPrice: BigInt.zero, network: network, error: error));
  }

  Future<AptosSignedTransaction> simulateTransaction(
      {required BigInt maxGasAmount, required BigInt gasUnitPrice});

  Future<IAptosTransactionSimulateInfo> simulateFee() async {
    final gasPrice = await getGasPrice();
    final transaction = await simulateTransaction(
        gasUnitPrice: gasPrice,
        maxGasAmount: AptosConstants.defaultMinGasAmount);

    final simulateResult =
        await simulate(rawTransaction: transaction.rawTransaction);
    if (!simulateResult.success) {
      throw AppException(simulateResult.vmStatus);
    }
    return IAptosTransactionSimulateInfo(
        vmStatus: simulateResult.vmStatus, simulateTx: simulateResult);
  }

  Future<void> estimateFee() async {
    _cancelable.cancel();
    await _lock.synchronized(() async {
      setDefaultFee();
      txFee.setPending();
      final fee = await MethodUtils.call(() async => await simulateFee());
      if (fee.isCancel) return;
      if (fee.hasError) {
        appLogger.error(
            runtime: runtimeType,
            functionName: "estimateFee",
            msg: fee.exception);
        setDefaultFee(error: fee.localizationError);
        return;
      }
      if (!fee.result.isSuccess) {
        setDefaultFee(error: fee.result.vmStatus);
        return;
      }
      txFee.setFee(AptosTransactionFee(
          maxGasAmount: fee.result.simulateTx.gasUsed,
          gasUnitPrice: fee.result.simulateTx.gasUnitPrice,
          simulateInfo: fee.result,
          network: network));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cancelable.cancel();
    txFee.dispose();
  }
}
