import 'dart:async';
import 'package:bitcoin_base/bitcoin_base.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:flutter/material.dart';
import 'package:on_chain_wallet/crypto/utils/bitcoin_cash/bitcoin_cash_utils.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/transaction/controllers/controller.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/transaction/widgets/transfer.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/transaction/widgets/transaction_ordering_view.dart';
import 'package:on_chain_wallet/future/wallet/transaction/transaction.dart';
import 'package:on_chain_wallet/wallet/models/models.dart';

class BitcoinTransactionTransferOperation
    extends BitcoinTransactionStateController {
  BitcoinTransferDetails? _lockedMax;
  BitcoinTransactionTransferOperation(
      {required super.walletProvider,
      required super.account,
      required super.address});
  List<BitcoinBaseOutput> _outputs = [];
  List<BitcoinUtxoInfo> _inputs = [];
  List<BitcoinUtxoInfo> get inputs => _inputs;

  String? _validateRecipients(List<BitcoinTransferDetails> recipients) {
    if (recipients.isEmpty) {
      return "at_least_one_recipient_required".tr;
    }
    for (final i in recipients) {
      if (!i.hasAmount) return "some_amount_fields_not_filled".tr;
    }
    return null;
  }

  final LiveFormField<bool, bool> rbf = LiveFormField(
      title: "replace_by_fee".tr,
      subtitle: "bitcoin_rbf_error".tr,
      value: false);

  final LiveFormField<TransactionOrdering, TransactionOrdering> ordering =
      LiveFormField(
          title: "transaction_ordering".tr,
          subtitle: "transaction_ordering_desc".tr,
          value: TransactionOrdering.bip69);

  late final LiveFormFields<BitcoinTransferDetails> recipients =
      LiveFormFields<BitcoinTransferDetails>(
    optional: false,
    title: "list_of_recipients".tr,
    subtitle: "amount_for_each_output".tr,
    onValidateError: (field, value) => _validateRecipients(value),
  );

  late final LiveFormField<BitcoinRemainTransferDetails,
          BitcoinRemainTransferDetails> remainingAmount =
      LiveFormField(
          title: "remaining_amount".tr,
          subtitle: "remaining_amount_and_receiver".tr,
          value: BitcoinRemainTransferDetails(
              recipient: account.getReceiptAddress(address.viewAddress) ??
                  ReceiptAddress(
                      view: address.viewAddress,
                      networkAddress: address.networkAddress),
              network: network),
          optional: false);

  late final LiveFormField<BitcoinRemainCashTokenTransferDetails,
          BitcoinRemainCashTokenTransferDetails> remainingCashTokenAmount =
      LiveFormField(
          title: "remaining_token_amount".tr,
          subtitle: "remaining_token_amount_and_receiver".tr,
          value: BitcoinRemainCashTokenTransferDetails(
              network: network,
              recipient: account.getReceiptAddress(address.viewAddress) ??
                  ReceiptAddress(
                      view: address.viewAddress,
                      networkAddress: address.networkAddress)),
          optional: false);

  BigInt getMaxInput([BitcoinTransferDetails? transfer]) {
    final remain = remainingAmount.value.amount.balance +
        (transfer?.amount.balance ?? BigInt.zero);
    if (remain.isNegative) return BigInt.zero;
    return remain;
  }

  BigInt getMinInput() {
    return network.coinParam.isBCH ? BCHUtils.minimumOutput : BigInt.zero;
  }

  @override
  BigInt getMaxFeeInput() {
    return remainingAmount.value.amount.balance + txFee.fee.fee.balance;
  }

  @override
  Future<void> estimateFee() async {
    if (!fieldsReady) return;
    await super.estimateFee();
  }

  String? filterAccount(BitcoinBaseAddress address) {
    if (network.coinParam.isBCH) return null;
    final addressStr = address.toAddress(network.coinParam.transacationNetwork);
    if (address == this.address.networkAddress ||
        recipients.value.any((e) => e.recipient.view == addressStr)) {
      return "address_already_exist".tr;
    }
    return null;
  }

  @override
  void onFeeUpdated(void _) {
    if (txFee.isPending) return;
    final lockedMax = _lockedMax;
    _onReceiptsUpdated();
    if (txFee.proccessed && lockedMax != null) {
      final remain = remainingAmount.value.amount.balance;
      BigInt amount = lockedMax.amount.balance;
      if (remain.isNegative) {
        amount -= remain;
      } else {
        amount += remain;
      }
      if (amount.isNegative) {
        amount = BigInt.zero;
      }
      lockedMax.updateBalance(amount);
      _onReceiptsUpdated();
      _lockedMax = null;
    }

    onStateUpdated();
  }

  void onUpdateOrdering(TransactionOrdering? ordering) {
    if (ordering == null) return;
    this.ordering.setValue(ordering);
  }

  void onUpdateRBF(bool? rbf) {
    if (rbf == null) return;
    this.rbf.setValue(rbf);
  }

  @override
  bool onUpdateMemo(String? memo) {
    if (super.onUpdateMemo(memo)) {
      _buildOutputs();
      onStateUpdated();
      estimateFee();
      return true;
    }
    return false;
  }

  @override
  void onRemoveMemo(BitcoinMemo memo) {
    super.onRemoveMemo(memo);
    _buildOutputs();
    onStateUpdated();
    estimateFee();
  }

  void _onReceiptsUpdated() {
    final totalOutput = totalUtxos.value.balance;
    final totalAmounts = recipients.value.fold(BigInt.zero,
        (previousValue, element) => previousValue + element.amount.balance);
    final tokenRemain = remainingCashTokenAmount.value.totalNativeAmount();
    remainingAmount.value.updateBalance(
        totalOutput - tokenRemain - totalAmounts - txFee.fee.fee.balance);
    _buildOutputs();
  }

  void onUpdateRecipients(List<ReceiptAddress<BitcoinBaseAddress>> addressess) {
    _lockedMax = null;
    final recipients = addressess
        .map((e) => BitcoinTransferDetails(recipient: e, token: network.token))
        .toList();
    this.recipients.addValues(recipients);
    _buildOutputs();
    onStateUpdated();
    estimateFee();
  }

  void onUpdateRecipientAmount(
      BitcoinTransferDetails recipient, BigInt amount, bool max) {
    _lockedMax = max ? recipient : null;
    recipient.updateBalance(amount);
    _onReceiptsUpdated();
    onStateUpdated();
    estimateFee();
  }

  void onRemoveRecipients(BitcoinTransferDetails recipient) {
    _lockedMax = null;
    final token = recipient.token;
    if (token != null) {
      remainingCashTokenAmount.value.onRemoveToken(token);
    }
    recipients.removeValue(recipient);
    recipient.dispose();
    _onReceiptsUpdated();
    onStateUpdated();
    estimateFee();
  }

  void onUpdateRemainingAccount(IBitcoinAddress address) {
    final recipient = account.getReceiptAddress(address.viewAddress) ??
        ReceiptAddress(
            view: address.viewAddress, networkAddress: address.networkAddress);
    remainingAmount.value.onUpdateRecipient(recipient);
  }

  void onUpdateRemainingTokenAccount(IBitcoinAddress address) {
    final recipient = account.getReceiptAddress(address.viewAddress) ??
        ReceiptAddress(
            view: address.viewAddress, networkAddress: address.networkAddress);
    remainingCashTokenAmount.value.onUpdateRecipient(recipient);
  }

  void onUpdateTransferToken(
      BitcoinTransferDetails recipient, BCHCashToken? token) {
    if (token == null) return;
    remainingCashTokenAmount.value.onUpdateTransferToken(recipient, token);
    remainingCashTokenAmount.notify();
    _buildOutputs();
    onStateUpdated();
    estimateFee();
  }

  void onRemoveTransferToken(BitcoinTransferDetails recipient,
      BitcoinCashCashTokenOperation transfer) {
    remainingCashTokenAmount.value.onRemoveToken(transfer);
    recipient.onRemoveToken(transfer.cashToken);
    remainingCashTokenAmount.notify();
    _buildOutputs();
    onStateUpdated();
    estimateFee();
  }

  void onUpdateTrasferTokenAmount(
      BitcoinTransferDetails recipient, BigInt amount) {
    final transfer = recipient.token;
    assert(transfer != null);
    if (transfer == null) return;
    remainingCashTokenAmount.value.onUpdateTransferAmount(transfer, amount);
    remainingCashTokenAmount.notify();
    recipient.onUpdateStatus();
    _buildOutputs();
    onStateUpdated();
    estimateFee();
  }

  void onUpdateBurnToken(BitcoinCashCashTokenRemainTransfer remain,
      {BigInt? amount}) {
    remainingCashTokenAmount.value.onUpdateBurn(remain, amount: amount);
    remainingCashTokenAmount.notify();
    _buildOutputs();
    onStateUpdated();
    estimateFee();
  }

  void onRemoveBurn(BitcoinCashCashTokenBurn burn) {
    remainingCashTokenAmount.value.onRemoveBurn(burn);
    remainingCashTokenAmount.notify();
    _buildOutputs();
    onStateUpdated();
    estimateFee();
  }

  void onUpdateRemindTokenAmount(
      BitcoinCashCashTokenRemainTransfer transfer, BigInt amount) {
    transfer.onUpdateAmount(amount);
    _onReceiptsUpdated();
    onStateUpdated();
  }

  @override
  void onSelectedUtxosChanged(List<BitcoinUtxoInfo> utxos) {
    final List<BCHCashToken> cashTokens = utxos
        .where((element) => element.cashToken != null)
        .map((e) => BCHCashToken(
            cashToken: e.cashToken!.cashToken,
            txHash: e.cashToken!.isNFT ? e.txHash : null))
        .toList();
    remainingCashTokenAmount.value.onUpdateTokenUtxos(cashTokens);
    _lockedMax = null;
    _inputs = utxos.toImutableList;
    for (final i in recipients.value) {
      final token = i.token;
      if (token == null) continue;
      i.onRemoveToken(token.cashToken);
    }
    _onReceiptsUpdated();
    onStateUpdated();
    estimateFee();
  }

  void _buildOutputs() {
    _outputs = List<BitcoinBaseOutput>.unmodifiable([
      ...recipients.value.map<BitcoinBaseOutput>((e) => e.toOutput()),
      if (remainingAmount.value.amount.largerThanZero)
        BitcoinOutput(
            address: remainingAmount.value.recipient.networkAddress,
            value: remainingAmount.value.amount.balance),
      ...remainingCashTokenAmount.value.toOutputs(),
      ...memos.value.map((e) => e.script)
    ]);
  }

  @override
  Future<IBitcoinTransactionData> buildTransactionData(
      {bool simulate = false}) async {
    final ordering = this.ordering.output.ordering;
    return IBitcoinTransactionData(
        fee: txFee.fee,
        ordering: ordering,
        enableRBF: rbf.output,
        utxos: _inputs.map((e) => e.utxo).toList(),
        destinations:
            recipients.value.expand((e) => e.toTransferInfo()).toList(),
        outputs: _outputs);
  }

  @override
  Future<List<IWalletTransaction<BitcoinWalletTransaction, IBitcoinAddress>>>
      buildWalletTransaction(
          {required IBitcoinSignedTransaction signedTx,
          required SubmitTransactionSuccess txId}) async {
    List<IWalletTransaction<BitcoinWalletTransaction, IBitcoinAddress>>
        transactions = [];
    final accounts = signedTx.transaction.accounts.toSet();
    for (final i in accounts) {
      final totalInputs = inputs
          .where((e) => e.address == i)
          .map((e) => e.utxo)
          .toList()
          .sumOfUtxosValue();
      if (totalInputs == BigInt.zero) continue;
      final tx = BitcoinWalletTransaction(
          txId: txId.txId,
          time: DateTime.now(),
          totalOutput: WalletTransactionIntegerAmount(
              amount: totalInputs, network: network),
          scriptHash: i.networkAddress.pubKeyHash(),
          outputs: [],
          network: network);
      transactions.add(IWalletTransaction(transaction: tx, account: i));
    }
    return transactions;
  }

  @override
  TransactionStateController cloneController(IBitcoinAddress address) {
    return BitcoinTransactionTransferOperation(
        walletProvider: walletProvider, account: account, address: address);
  }

  @override
  TransactionStateStatus getStateStatus() {
    final status = super.getStateStatus();
    if (!status.isReady) return status;
    if (!fieldsReady) {
      return TransactionStateStatus.error();
    }
    for (final i in recipients.value) {
      final status = i.status;
      if (!status.isReady) return status;
    }
    String? simulateError =
        txFee.fee.hasError ? "transaction_simulation_failed".tr : null;
    return TransactionStateStatus.insufficient(remainingAmount.value.amount,
        warning: simulateError);
  }

  @override
  TransactionOperations get operation => BitcoinTransactionOperations.transfer;

  @override
  Widget widgetBuilder(BuildContext context) {
    return BitcoinTransactionTransferTokenWidget(form: this);
  }

  @override
  Future<void> signAndSendTransaction({BuildContext? context}) async {
    assert(context != null);
    if (ordering.value == TransactionOrdering.manually) {
      if (context == null) return;
      final ordering = await context.openSliverBottomSheet<
              (List<UtxoWithAddress>, List<BitcoinBaseOutput>)>(
          "transaction_ordering".tr,
          bodyBuilder: (c) => TransactionOrderingView(
              inputs: _inputs.map((e) => e.utxo).toList(),
              controller: c,
              outputs: _outputs,
              network: network),
          initiaalExtend: 1);
      if (ordering == null) {
        return;
      }
      final outputs = ordering.$2;
      _outputs = List.generate(_outputs.length, (i) {
        return _outputs.firstWhere((e) => e == outputs[i]);
      });
      final inputs = ordering.$1;
      _inputs = List.generate(_inputs.length, (i) {
        return _inputs.firstWhere((e) => e.utxo == inputs[i]);
      });
    }
    return super.signAndSendTransaction(context: context);
  }

  @override
  List<LiveFormField<Object?, Object>> get fields =>
      [rbf, ordering, recipients, remainingAmount, remainingCashTokenAmount];
  @override
  void dispose() {
    remainingAmount.value.dispose();
    remainingCashTokenAmount.value.dispose();
    super.dispose();
  }
}
