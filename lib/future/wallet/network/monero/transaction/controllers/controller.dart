import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/transaction.dart';
import 'package:on_chain_wallet/future/wallet/network/monero/transaction/controllers/utxos.dart';
import 'package:on_chain_wallet/future/wallet/network/monero/transaction/types/types.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';
import 'package:on_chain_wallet/future/wallet/transaction/transaction.dart';
import 'fee.dart';
import 'provider.dart';
import 'signer.dart';

abstract class MoneroTransactionStateController
    extends BaseMoneroTransactionController
    with
        MoneroTransactionApiController,
        MoneroTransactionFeeController,
        MoneroTransactionUtxosController,
        MoneroTransactionSignerController {
  Token get transferToken;

  MoneroTransactionStateController(
      {required super.walletProvider,
      required super.account,
      required super.address});

  @override
  Future<IMoneroTransactionData> simulateTransaction() async {
    final transaction = await buildTransactionData(simulate: true);
    return transaction;
  }

  @override
  Future<IMoneroSignedTransaction> signTransaction(
      IMoneroTransaction transaction,
      {bool fakeSignature = false}) async {
    final signedTx = await signTransactionInternal(transaction);
    return signedTx;
  }

  @override
  Future<IMoneroTransaction> buildTransaction({bool simulate = false}) async {
    final transactionData = await buildTransactionData(simulate: simulate);
    final payments = transactionData.payments
        .map((e) => e.paymet.toLockedPayment())
        .toList();
    final MoneroRingOutput ringOutput = await buildRingOutput(payments);
    final spendablePayment = await generatePaymentOutputsRings(
        payments: payments,
        outKeysRequestOrder: ringOutput.orderedIndexes,
        outKeysRequests: ringOutput.indexes,
        fakeOutsLength: MoneroConst.ringSize - 1);
    return IMoneroTransaction(
        account: address,
        transactionData: transactionData,
        fee: txFee.fee.fee.balance,
        ringOutput: ringOutput,
        spendablePayment: spendablePayment);
  }

  @override
  Future<SubmitTransactionResult> submitTransaction(
      {required IMoneroSignedTransaction signedTransaction}) async {
    final response =
        await client.sendTx(signedTransaction.finalTransactionData.txBytes);
    if (response.isOk) {
      return SubmitTransactionSuccess(
          txId: signedTransaction.finalTransactionData.txData.txID,
          signedTransaction: signedTransaction);
    }
    return SubmitTransactionFailed("transaction_submission_error"
        .tr
        .replaceOne(response.getErrorMessage() ?? ''));
  }

  @override
  Widget onTxCompleteWidget(
      {required IMoneroSignedTransaction signedTx,
      required MoneroWalletTransaction transaction,
      required SubmitTransactionSuccess<IMoneroSignedTransaction> txId,
      required MoneroChain account}) {
    return SuccessTransactionTextView(
      txId: txId.txId,
      account: account,
      transaction: transaction,
      additionalWidget: (context) {
        return FixedElevatedButton(
            onPressed: () {
              context.openSliverDialog(
                  widget: (p0) => TransactionModalView(
                      chain: account, transaction: transaction),
                  label: "transaction".tr);
            },
            child: Text("show_proofs".tr));
      },
    );
  }

  @override
  Future<void> initForm(MoneroClient client,
      {bool updateAccount = true}) async {
    await super.initForm(client, updateAccount: updateAccount);
    await initAccountUtxos(account: account, address: address);
  }
}
