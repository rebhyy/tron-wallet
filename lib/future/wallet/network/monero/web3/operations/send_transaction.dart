import 'dart:async';
import 'package:flutter/material.dart';
import 'package:monero_dart/monero_dart.dart';
import 'package:on_chain_wallet/future/state_managment/extension/extension.dart';
import 'package:on_chain_wallet/future/wallet/network/monero/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/network/monero/web3/controllers/controllers.dart';
import 'package:on_chain_wallet/future/wallet/network/monero/web3/pages/send_transaction.dart';
import 'package:on_chain_wallet/future/wallet/transaction/fields/fields.dart';
import 'package:on_chain_wallet/future/wallet/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/core/web3.dart';
import 'package:on_chain_wallet/wallet/api/client/networks/monero/monero.dart';
import 'package:on_chain_wallet/wallet/constant/networks/monero.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/networks/monero/models/chain.dart';
import 'package:on_chain_wallet/wallet/models/others/models/receipt_address.dart';
import 'package:on_chain_wallet/wallet/models/transaction/core/transaction.dart';
import 'package:on_chain_wallet/wallet/models/transaction/networks/monero.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/params/models/transaction.dart';

class WebMoneroSignTransactionStateController
    extends Web3MoneroTransactionStateController<Web3MoneroTransactionResponse,
        Web3MoneroSendTransaction> {
  IMoneroTransactionData? _transactionData;
  IMoneroTransactionData get transactionData => _transactionData!;
  List<MoneroOutputDetailsWithAddress> _utxos = [];
  WebMoneroSignTransactionStateController(
      {required super.walletProvider, required super.request});

  late final LiveFormField<MoneroTransferDetails, MoneroTransferDetails>
      remainingAmount = LiveFormField(
          title: "remaining_amount".tr,
          subtitle: "remaining_amount_and_receiver".tr,
          value: MoneroTransferDetails(
              allowNegativeAmount: true,
              recipientUpdateble: true,
              recipient:
                  account.getReceiptAddress(defaultAccount.viewAddress) ??
                      ReceiptAddress(
                          view: defaultAccount.viewAddress,
                          networkAddress: defaultAccount.networkAddress),
              token: network.token),
          optional: false);

  BigInt maxFeeInput() {
    return defaultAccount.address.currencyBalance;
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
        account: defaultAccount,
        transactionData: transactionData,
        fee: txFee.fee.fee.balance,
        ringOutput: ringOutput,
        spendablePayment: spendablePayment);
  }

  @override
  Future<IMoneroTransactionData> buildTransactionData(
      {bool simulate = false}) async {
    return IMoneroTransactionData(
      change: remainingAmount.value.hasAmount
          ? MoneroTxDestination(
              amount: remainingAmount.value.amount.balance,
              address: remainingAmount.value.recipient.networkAddress)
          : null,
      payments: _utxos,
      destinations: params.destintions
          .map((e) => IMoneroTransactionDataTransfer(
              recipient:
                  getOrCreateAddressInfo(e.destination, e.destination.address),
              amount: IntegerBalance.token(e.amount, network.token,
                  allowNegative: false, immutable: true)))
          .toList(),
    );
  }

  @override
  Future<List<IWalletTransaction<MoneroWalletTransaction, IMoneroAddress>>>
      buildWalletTransaction(
          {required IMoneroSignedTransaction signedTx,
          required SubmitTransactionSuccess<IMoneroSignedTransaction>?
              txId}) async {
    if (txId == null) return [];
    final List<IWalletTransaction<MoneroWalletTransaction, IMoneroAddress>>
        transactions = [];
    final signers = signedTx.transaction.transactionData.payments
        .map((e) => e.address)
        .toSet();
    final destinations = signedTx.transaction.transactionData.destinations
        .map((e) => MoneroWalletTransactionOutput(
            amount: WalletTransactionIntegerAmount(
                amount: e.amount.balance, network: network),
            to: e.recipient.networkAddress))
        .toList();
    for (final i in signers) {
      final payments = signedTx.transaction.transactionData.payments
          .where((e) => e.address == i)
          .toList();
      final transaction = MoneroWalletTransaction(
          txId: txId.txId,
          time: DateTime.now(),
          network: network,
          totalOutput: WalletTransactionIntegerAmount(
              amount: payments.fold<BigInt>(
                  BigInt.zero, (p, c) => p + c.paymet.amount),
              network: network),
          outputs: destinations,
          txKeys: signedTx.finalTransactionData.txData.txKeys
              .map((e) => e.key)
              .toList());
      transactions
          .add(IWalletTransaction(transaction: transaction, account: i));
    }
    return transactions;
  }

  @override
  Future<
          Web3RequestTransactionResponseData<Web3MoneroTransactionResponse,
              SubmitTransactionSuccess<IMoneroSignedTransaction>>>
      getResponse() async {
    final result = await buildSignAndSendTransaction();
    return Web3RequestTransactionResponseData.submitTx(
        response: Web3MoneroTransactionResponse(
            proofs: result.signedTransaction.finalTransactionData.destinations
                .map((e) => Web3MoneroTransactionProofsResponse(
                    address: e.destination.address.address, proof: e.proof!))
                .toList(),
            txId: result.txId),
        txIds: [result]);
  }

  String? filterRemainAccount(IMoneroAddress address) {
    if (address.networkAddress ==
            remainingAmount.value.recipient.networkAddress ||
        transactionData.destinations
            .any((e) => e.recipient.networkAddress == address.networkAddress)) {
      return "address_already_exist".tr;
    }
    return null;
  }

  void onUpdateRemainingAccount(IMoneroAddress? address) {
    if (address == null || filterRemainAccount(address) != null) return;
    final recipient = account.getReceiptAddress(address.viewAddress) ??
        ReceiptAddress(
            view: address.viewAddress, networkAddress: address.networkAddress);
    remainingAmount.value.updateRecipientAddress(recipient);
    remainingAmount.notify();
    onStateUpdated();
  }

  void _onReceiptsUpdated() {
    final totalOutput = totalUtxos.value.balance;
    final totalAmounts = transactionData.destinations.fold(BigInt.zero,
        (previousValue, element) => previousValue + element.amount.balance);
    remainingAmount.value
        .updateBalance(totalOutput - totalAmounts - txFee.fee.fee.balance);
    remainingAmount.notify();
  }

  @override
  Future<void> estimateFee() async {
    if (_utxos.isEmpty) return;
    return super.estimateFee();
  }

  @override
  TransactionStateStatus getStateStatus() {
    if (_utxos.isEmpty) return TransactionStateStatus.error();
    if (!txFee.fee.isManual && txFee.isPending) {
      return TransactionStateStatus.error();
    }
    if (!txFee.hasFee) {
      return TransactionStateStatus.error(error: "fee_zero_validator_desc".tr);
    }
    String? simulateError =
        txFee.fee.hasError ? "transaction_simulation_failed".tr : null;
    return TransactionStateStatus.insufficient(remainingAmount.value.amount,
        warning: simulateError);
  }

  @override
  void onSelectedUtxosChanged(List<MoneroOutputDetailsWithAddress> utxos) {
    _utxos = utxos;
    _onReceiptsUpdated();
    onStateUpdated();
    estimateFee();
  }

  @override
  Future<IMoneroSignedTransaction> signTransaction(
      IMoneroTransaction transaction,
      {bool fakeSignature = false}) async {
    return await signTransactionInternal(transaction, withProof: true);
  }

  @override
  Future<IMoneroTransactionData> simulateTransaction() async {
    return await buildTransactionData(simulate: true);
  }

  @override
  Widget widgetBuilder(BuildContext context) {
    return Web3MoneroSignTransactionStateView(this);
  }

  void onFeeUpdated(void _) {
    _onReceiptsUpdated();
    onStateUpdated();
  }

  StreamSubscription<void>? _feeListener;

  @override
  Future<void> initForm(MoneroClient client) async {
    await super.initForm(client);
    _transactionData = await buildTransactionData();
    await initAccountUtxos(account: account, address: defaultAccount);
    _feeListener = txFee.stream.listen(onFeeUpdated);
    estimateFee();
  }

  @override
  void dispose() {
    super.dispose();
    _feeListener?.cancel();
    _feeListener = null;
  }
}
