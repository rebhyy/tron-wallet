import 'dart:async';
import 'package:on_chain_wallet/app/error/exception/app_exception.dart';
import 'package:on_chain_wallet/future/state_managment/extension/extension.dart';
import 'package:on_chain_wallet/future/wallet/network/ton/transaction/controllers/provider.dart';
import 'package:on_chain_wallet/future/wallet/network/ton/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/transaction.dart';
import 'package:ton_dart/ton_dart.dart';
import 'fee.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';
import 'signer.dart';

abstract class TonTransactionStateController2
    extends BaseTonTransactionController
    with
        TonTransactionApiController,
        TonTransactionFeeController,
        TonTransactionSignerController {
  final VersionedWalletContract walletContract;
  int get walletVesion => walletContract.type.version;

  TonTransactionStateController2(
      {required super.walletProvider,
      required super.account,
      required super.address})
      : walletContract = address.toWalletContract();

  @override
  Future<ITonTransaction> buildTransaction({bool simulate = false}) async {
    final transactionData = await buildTransactionData(simulate: simulate);
    final transaction = address.context.buildTransaction(
        actions: transactionData.messages,
        state: walletContract.state!,
        seqno: transactionData.seqno,
        chain: network.coinParam.chain,
        timeOut: transactionData.timeout);
    return ITonTransaction(
        account: address,
        transactionData: transactionData,
        transaction: transaction,
        stateInit: transactionData.seqno == 0
            ? walletContract.state!.initialState()
            : null);
  }

  @override
  Future<ITonSignedTransaction> signTransaction(ITonTransaction transaction,
      {bool fakeSignature = false}) async {
    final signedTransaction = await signTransactionInternal(
        transaction: transaction.transaction,
        signer: transaction.account,
        fakeSignature: fakeSignature,
        stateInit: transaction.stateInit);
    return ITonSignedTransaction(
        transaction: transaction,
        signatures: signedTransaction.signatures,
        finalTransactionData: signedTransaction.message);
  }

  @override
  Future<TonSimulateTransaction> simulateTransaction() async {
    final transaction = await buildTransaction(simulate: true);
    final signedTransaction =
        await signTransaction(transaction, fakeSignature: true);
    return TonSimulateTransaction(
        message: signedTransaction.finalTransactionData, address: address);
  }

  @override
  Future<List<IWalletTransaction<TonWalletTransaction, ITonAddress>>>
      buildWalletTransaction(
          {required ITonSignedTransaction signedTx,
          required SubmitTransactionSuccess txId}) async {
    final payments = signedTx.transaction.transactionData.payment ?? [];
    final outputs = payments
        .map((e) => TonWalletTransactionTransferOutput(
              to: e.recipient,
              amount: WalletTransactionIntegerAmount(
                  amount: e.amount,
                  network: network,
                  token: e.token?.token,
                  tokenIdentifier: e.token?.identifier),
            ))
        .toList();
    final nativePayment = payments.where((e) => e.token == null).toList();
    final totalNativeAmount =
        nativePayment.fold(BigInt.zero, (p, c) => p + c.amount);
    final transaction = TonWalletTransaction(
        txId: txId.txId,
        outputs: outputs,
        network: network,
        totalOutput: WalletTransactionIntegerAmount(
            amount: totalNativeAmount, network: network));
    return [IWalletTransaction(transaction: transaction, account: address)];
  }

  @override
  Future<SubmitTransactionResult> submitTransaction(
      {required ITonSignedTransaction signedTransaction}) async {
    final txId = await client.submitBoc(boc: signedTransaction.externalMessage);
    return SubmitTransactionSuccess(
        txId: txId.$1,
        warning: txId.$2 ? null : "tx_submit_response_failed_desc".tr,
        signedTransaction: signedTransaction);
  }

  @override
  Future<void> initForm(TonClient client, {bool updateAccount = true}) async {
    await super.initForm(client, updateAccount: updateAccount);
    final state = await getAccountState(walletContract);
    if (state.state.isFrozen) {
      throw AppException("ton_address_is_freez_desc");
    }
  }
}
