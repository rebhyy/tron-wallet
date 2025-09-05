import 'dart:async';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:flutter/material.dart';
import 'package:on_chain_wallet/app/error/exception/app_exception.dart';
import 'package:on_chain_wallet/app/utils/price/utils.dart';
import 'package:on_chain_wallet/crypto/utils/substrate/substrate.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/network/substrate/transaction/controllers/controller.dart';
import 'package:on_chain_wallet/future/wallet/network/substrate/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/network/substrate/transaction/widgets/transfer.dart';
import 'package:on_chain_wallet/future/wallet/transaction/transaction.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

class SubstrateTransactionTransferOperation
    extends SubstrateTransactionStateController {
  SubstrateTransactionTransferOperation(
      {required super.walletProvider,
      required super.account,
      required super.address});

  bool get allowAddTransfer => supportBatch || recipients.value.isEmpty;
  SubstrateTransferDetails? _lockedMax;
  IntegerBalance? _existentialDeposit;

  final LiveFormField<SubstrateTransferType, SubstrateTransferType>
      transferMethod = LiveFormField(
          title: "method_name".tr,
          value: SubstrateTransferType.transferAllowDeath);

  late final LiveFormFields<SubstrateTransferDetails> recipients =
      LiveFormFields<SubstrateTransferDetails>(
          optional: false,
          title: "list_of_recipients".tr,
          subtitle: "amount_for_each_output".tr,
          onValidateError: (_, value) => _validateRecipients(value));

  String? _validateRecipients(List<SubstrateTransferDetails> recipients) {
    if (recipients.isEmpty) {
      return "at_least_one_recipient_required".tr;
    }
    for (final i in recipients) {
      if (!i.hasAmount) return "some_amount_fields_not_filled".tr;
    }
    return null;
  }

  String? filterAccount(BaseSubstrateAddress address) {
    if (address == this.address.networkAddress ||
        recipients.value.any((e) => e.recipient.networkAddress == address)) {
      return "address_already_exist".tr;
    }
    return null;
  }

  void onUpdateRecipients(
      List<ReceiptAddress<BaseSubstrateAddress>> addressess) {
    final recipients = addressess
        .map(
            (e) => SubstrateTransferDetails(recipient: e, token: network.token))
        .toList();
    this.recipients.addValues(recipients);
    onStateUpdated();
    estimateFee();
  }

  void onRemoveRecipients(SubstrateTransferDetails recipient) {
    _lockedMax = null;
    recipients.removeValue(recipient);
    recipient.dispose();
    onStateUpdated();
    estimateFee();
  }

  void onUpdateTransferMethod(SubstrateTransferType? method) {
    if (method == null) return;
    transferMethod.setValue(method);
    onStateUpdated();
    estimateFee();
  }

  BigInt getMaxInput(SubstrateTransferDetails recipient) {
    final total = recipients.value
        .fold<BigInt>(BigInt.zero, (p, c) => p + c.amount.balance);
    BigInt max = address.address.currencyBalance -
        total +
        recipient.amount.balance -
        txFee.fee.fee.balance;
    if (transferMethod.output == SubstrateTransferType.transferKeepAlive) {
      final existentialDeposit = _existentialDeposit?.balance ?? BigInt.zero;
      max -= existentialDeposit;
    }
    if (max.isNegative) return BigInt.zero;
    return max;
  }

  void onUpdateAmount(
      SubstrateTransferDetails recipient, BigInt amount, bool max) {
    _lockedMax = max ? recipient : null;
    recipient.updateBalance(amount);
    onStateUpdated();
    estimateFee();
  }

  @override
  void onFeeUpdated(void _) {
    if (!txFee.isPending) {
      final last = _lockedMax;
      if (last != null) {
        last.updateBalance(getMaxInput(last));
        _lockedMax = null;
      }
    }
    onStateUpdated();
  }

  @override
  Future<void> estimateFee() async {
    if (!fieldsReady) return;
    return super.estimateFee();
  }

  @override
  TransactionStateStatus getStateStatus() {
    final status = super.getStateStatus();
    if (!status.isReady) return status;
    final total = recipients.value
        .fold<BigInt>(BigInt.zero, (p, c) => p + c.amount.balance);
    final r = address.address.currencyBalance - total - txFee.fee.fee.balance;
    String? simulateError =
        txFee.fee.hasError ? "transaction_simulation_failed".tr : null;
    if (r.isNegative) {
      return TransactionStateStatus.insufficient(
          IntegerBalance.token(r, network.token),
          warning: simulateError);
    }
    final existentialDeposit = _existentialDeposit;
    if (existentialDeposit != null) {
      if (r < existentialDeposit.balance) {
        if (transferMethod.output == SubstrateTransferType.transferKeepAlive) {
          return TransactionStateStatus.error(
              error: "substrate_keep_alive_min_desc".tr.replaceOne(
                  PriceUtils.priceWithCoinName(
                      existentialDeposit.viewPrice, network.token.symbol)));
        } else {
          return TransactionStateStatus.ready(
              warning: "account_will_be_deactivated_after_transaction".tr);
        }
      }
    }

    return TransactionStateStatus.ready(warning: simulateError);
  }

  List<Map<String, dynamic>> _toCalls() {
    final memos = this.memos.value;
    final remarks = SubstrateUtils.buildRemarks(memos);
    final bool batch = recipients.value.length + memos.length > 1;
    final messages = recipients.value
        .map((e) => SubstrateDefaultTransfer(
                address: e.recipient.networkAddress, value: e.amount.balance)
            .toJson(usePallet: batch, method: transferMethod.value))
        .toList();
    return [...messages, ...remarks];
  }

  @override
  Future<ISubstrateTransaction> buildTransaction(
      {bool simulate = false}) async {
    final transactionData = await buildTransactionData(simulate: simulate);
    int nonce = 0;
    if (!simulate) {
      nonce = await getAccountNonce(address.networkAddress);
    }
    final blockInfo = await finalizeBlockWithEra();
    final List<int> genesis = metadata.genesisBytes();

    final calls = SubstrateUtils.buildMethod(_toCalls());
    final bool batch = recipients.value.length + memos.value.length > 1;

    final List<int> messageBytes = switch (batch) {
      false => metadata.metadata.encodeCall(
          palletNameOrIndex: APPSubstrateConst.balancePalletName,
          value: calls,
          fromTemplate: false),
      _ => metadata.metadata.encodeCall(
          palletNameOrIndex: APPSubstrateConst.utilityPalletName,
          value: calls,
          fromTemplate: false)
    };
    final extrinsic = SubstrateDefaultExtrinsic(
        era: blockInfo.era,
        nonce: nonce,
        specVersion: metadata.runtimeVersion.specVersion,
        transactionVersion: metadata.runtimeVersion.transactionVersion,
        genesis: genesis,
        mortality: blockInfo.blockHashBytes);
    final extrinsicTypes = metadata.extrinsic;
    final extraFields = extrinsic.encode(
        fields: extrinsicTypes.extrinsicPayloadValidators,
        metadata: metadata.metadata);
    final List<int> encodeBytes =
        [...messageBytes, ...extraFields].asImmutableBytes;
    final extrinsicInfo = ExtrinsicPayloadInfo(
        serializedExtrinsic: encodeBytes,
        method: messageBytes,
        extrinsic: extrinsic);
    return ISubstrateTransaction(
        account: address,
        transactionData: transactionData,
        payload: extrinsicInfo);
  }

  @override
  Future<ISubstrateTransactionData> buildTransactionData(
      {bool simulate = false}) async {
    final payments = recipients.value
        .map((e) => ISubstrateTransactionDataTokenTransfer(
            recipient: e.recipient.networkAddress, amount: e.amount.balance))
        .toList();
    return ISubstrateTransactionData(fee: txFee.fee, payment: payments);
  }

  @override
  Future<
      List<
          IWalletTransaction<SubstrateWalletTransaction,
              ISubstrateAddress>>> buildWalletTransaction(
      {required ISubstrateSignedTransaction signedTx,
      required SubmitTransactionSuccess txId}) async {
    final destinations = signedTx.transaction.transactionData.payment ?? [];
    final outputs = destinations
        .map((e) => SubstrateWalletTransactionTransferOutput(
            to: e.recipient,
            amount: WalletTransactionIntegerAmount(
                amount: e.amount, network: network)))
        .toList();
    final transaction = SubstrateWalletTransaction(
        txId: txId.txId,
        network: network,
        block: txId.block!,
        outputs: outputs,
        totalOutput: WalletTransactionIntegerAmount(
            amount:
                destinations.fold<BigInt>(BigInt.zero, (p, c) => p + c.amount),
            network: network),
        extrinsics: signedTx.finalTransactionData.serializeHex());
    return [
      IWalletTransaction(
          transaction: transaction, account: signedTx.transaction.account)
    ];
  }

  @override
  TransactionStateController cloneController(ISubstrateAddress address) {
    return SubstrateTransactionTransferOperation(
        walletProvider: walletProvider, account: account, address: address);
  }

  @override
  Widget widgetBuilder(BuildContext context) {
    return SubstrateTransactionTransferWidget(form: this);
  }

  @override
  Future<void> initForm(SubstrateClient client,
      {bool updateAccount = true}) async {
    await super.initForm(client, updateAccount: updateAccount);
    if (!client.metadata.supportNativeTransfer) {
      throw AppException("substrate_disable_transfer_option_desc");
    }
    transferMethod.setValue(client.metadata.transferTypes.first);
    final existentialDeposit = metadata.existentialDeposit;
    if (existentialDeposit != null) {
      _existentialDeposit =
          IntegerBalance.token(existentialDeposit, network.token);
    }
  }

  @override
  TransactionOperations get operation =>
      SubstrateTransactionOperations.transfer;

  @override
  List<LiveFormField<Object?, Object>> get fields =>
      [recipients, transferMethod];
}

/// 50000262
