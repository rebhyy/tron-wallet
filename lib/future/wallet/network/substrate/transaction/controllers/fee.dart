import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/wallet/network/substrate/transaction/types/types.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';
import 'package:on_chain_wallet/wallet/models/networks/substrate/models/metadata_fields.dart';

import 'provider.dart';

mixin SubstrateTransactionFeeController on SubstrateTransactionApiController {
  WalletSubstrateNetwork get network;
  final Cancelable _cancelable = Cancelable();
  final _lock = SynchronizedLock();

  late final SubstrateTransactionFeeData txFee = SubstrateTransactionFeeData(
      select: SubstrateTransactionFee.init(network), feeToken: network.token);

  void setDefaultFee({String? error}) {
    txFee.setFee(SubstrateTransactionFee.init(network, error: error));
  }

  Future<ExtrinsicInfo> simulateTransaction();

  Future<SubstrateTransactionFee> simulateFee() async {
    final signexTx = await simulateTransaction();
    final feeData = await client.queryFeeDetails(
        extrinsic: signexTx.serialize(encodeLength: false));
    return SubstrateTransactionFee.fromFeeDetails(
        fee: feeData, network: network);
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
