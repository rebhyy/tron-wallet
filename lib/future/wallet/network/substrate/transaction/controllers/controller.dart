import 'dart:async';
import 'package:on_chain_wallet/future/wallet/network/substrate/transaction/controllers/provider.dart';
import 'package:on_chain_wallet/future/wallet/network/substrate/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/transaction.dart';
import 'fee.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';

import 'memo.dart';
import 'signer.dart';

abstract class SubstrateTransactionStateController
    extends BaseSubstrateTransactionController
    with
        SubstrateTransactionApiController,
        SubstrateTransactionFeeController,
        SubstrateTransactionMemoController,
        SubstrateTransactionSignerController {
  SubstrateChainMetadata get metadata => client.metadata;

  bool get supportRemarks => client.metadata.supportRemarks;
  bool get supportBatch => client.metadata.supportBatch;

  SubstrateTransactionStateController(
      {required super.walletProvider,
      required super.account,
      required super.address});

  @override
  void onUpdateMemo(String? memo) {
    super.onUpdateMemo(memo);
    onStateUpdated();
    estimateFee();
  }

  @override
  void onRemoveMemo(String memo) {
    super.onRemoveMemo(memo);
    onStateUpdated();
    estimateFee();
  }

  @override
  Future<ISubstrateTransactionData> buildTransactionData(
      {bool simulate = false}) async {
    return ISubstrateTransactionData(fee: txFee.fee);
  }

  Future<ExtrinsicInfo> createSignedExtrinsic({
    required ExtrinsicPayloadInfo transaction,
    required List<int> signature,
  }) async {
    return metadata.createExtrinsic(
        signature: signature,
        address: address.networkAddress,
        algorithm: address.keyIndex.currencyCoin.conf.type,
        payload: transaction);
  }

  @override
  Future<ISubstrateSignedTransaction> signTransaction(
      ISubstrateTransaction transaction,
      {bool fakeSignature = false}) async {
    final signedTransaction = await signTransactionInternal(
        payloadBytes: transaction.payload.payloadBytes,
        signer: address,
        fakeSignature: fakeSignature);
    final extrinsic = await createSignedExtrinsic(
        transaction: transaction.payload,
        signature: signedTransaction.signatures[0]);
    return ISubstrateSignedTransaction(
        transaction: transaction,
        signatures: signedTransaction.signatures,
        finalTransactionData: extrinsic);
  }

  @override
  Future<ExtrinsicInfo> simulateTransaction() async {
    final transaction = await buildTransaction();
    final signexTx = await signTransaction(transaction, fakeSignature: true);
    return signexTx.finalTransactionData;
  }

  @override
  Future<SubmitTransactionResult> submitTransaction(
      {required ISubstrateSignedTransaction signedTransaction}) async {
    final txId = await client.broadcastTransaction(
        signedTransaction.finalTransactionData.serialize());
    return SubmitTransactionSuccess(
        txId: txId.txId,
        block: txId.block,
        signedTransaction: signedTransaction);
  }
}
