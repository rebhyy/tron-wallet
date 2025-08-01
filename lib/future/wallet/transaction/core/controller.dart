import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/future.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/types.dart';
import 'package:on_chain_wallet/wallet/api/client/core/client.dart';
import 'package:on_chain_wallet/wallet/models/models.dart';

import '../fields/fields.dart';
import '../types/types.dart';

mixin TransactionStatePageController<
    SUCCESS extends SubmitTransactionSuccess,
    SIGNEDTX,
    CHAINTRANSACTION extends ChainTransaction,
    ACCOUNT extends Chain> on DisposableMixin {
  WalletNetwork get network;
  final StreamPageProgressController pageKey =
      StreamPageProgressController(initialStatus: StreamWidgetStatus.progress);

  void setPageIdle() {
    pageKey.backToIdle();
  }

  void setPageProgress({String? text}) {
    if (text == null) {
      pageKey.progress();
    } else {
      pageKey.progressText(text);
    }
  }

  Widget onTxCompleteWidget({
    required SIGNEDTX signedTx,
    required CHAINTRANSACTION transaction,
    required SUCCESS txId,
    required ACCOUNT account,
  }) {
    return SuccessTransactionTextView(
        txId: txId.txId,
        warning: txId.warning,
        account: account,
        transaction: transaction);
  }

  void setTxComplete({
    required SIGNEDTX signedTx,
    required CHAINTRANSACTION transaction,
    required SUCCESS txId,
    required ACCOUNT account,
  }) {
    pageKey.success(
        progressWidget: onTxCompleteWidget(
            signedTx: signedTx,
            transaction: transaction,
            txId: txId,
            account: account),
        backToIdle: false);
    final txUrl = network.getTransactionExplorer(txId.txId);
    appLogger.debug(
        runtime: runtimeType,
        functionName: "setTxComplete",
        msg: "txID: ${txId.txId}. $txUrl");
  }

  void setPageError(String error,
      {bool backToIdle = false, bool showBackButton = true}) {
    pageKey.errorText(error,
        backToIdle: backToIdle, showBackButton: showBackButton);
  }

  @override
  void dispose() {
    pageKey.dispose();
    super.dispose();
    appLogger.debug(functionName: "dispose", runtime: runtimeType, msg: "Page");
  }
}

abstract class TransactionStateController<
        ACCOUNT extends ChainAccount,
        CLIENT extends NetworkClient,
        NETWORK extends WalletNetwork,
        C extends APPCHAINACCOUNTCLIENTNETWORK<ACCOUNT, CLIENT, NETWORK>,
        TRANSACTIONDATA extends ITransactionData,
        TRANSACTION extends ITransaction<TRANSACTIONDATA, ACCOUNT>,
        SIGNEDTX extends ISignedTransaction<TRANSACTION, Object>,
        T extends ChainTransaction,
        SUCCESS extends SubmitTransactionSuccess<SIGNEDTX>>
    with
        DisposableMixin,
        StreamStateController,
        TransactionStatePageController<SUCCESS, SIGNEDTX, T, C> {
  final lock = SynchronizedLock();
  StreamSubscription<void>? _feeListener;
  StreamSubscription<IntegerBalance>? _accountListener;
  final StreamValue<TransactionStateStatus> stateStatus =
      StreamValue(TransactionStateStatus.error());
  TransactionFeeData get txFee;
  TransactionOperations get operation;
  final ACCOUNT _address;
  ACCOUNT get address => _address;
  late CLIENT _client;
  CLIENT get client => _client;
  final WalletProvider walletProvider;
  final C account;
  @override
  final NETWORK network;
  TransactionStateController(
      {required this.walletProvider,
      required this.account,
      required ACCOUNT address})
      : network = account.network,
        _address = address;
  TransactionStateController cloneController(ACCOUNT address);
  Widget widgetBuilder(BuildContext context);
  Future<TRANSACTION> buildTransaction({bool simulate = false});
  Future<SIGNEDTX> signTransaction(TRANSACTION transaction,
      {bool fakeSignature = false});
  Future<SubmitTransactionResult> submitTransaction(
      {required SIGNEDTX signedTransaction});
  Future<List<IWalletTransaction<T, ACCOUNT>>> buildWalletTransaction(
      {required SIGNEDTX signedTx, required SUCCESS txId});
  Future<TRANSACTIONDATA> buildTransactionData({bool simulate = false});
  Future<void> estimateFee();
  BigInt getMaxFeeInput() {
    return address.address.currencyBalance;
  }

  void onFeeUpdated(void _) {
    onStateUpdated();
  }

  void onAccountUpdated() {
    onStateUpdated();
  }

  TransactionStateStatus getStateStatus() {
    if (!fieldsFiled) {
      return TransactionStateStatus.error();
    }
    if (!txFee.fee.isManual && txFee.isPending) {
      return TransactionStateStatus.error();
    }

    final fieldsError = this.fieldsError;
    if (fieldsError != null) {
      return TransactionStateStatus.error();
    }
    if (txFee.feeMode.isDynamicFee && !txFee.hasFee) {
      return TransactionStateStatus.error(error: "fee_zero_validator_desc".tr);
    }
    return TransactionStateStatus.ready();
  }

  Future<void> initForm(CLIENT client, {bool updateAccount = true}) async {
    _feeListener = txFee.stream.listen(onFeeUpdated);
    _accountListener = account.address.address.balance.stream
        .listen((_) => onAccountUpdated());
    if (updateAccount) account.updateAddressBalance(address, tokens: false);
  }

  Future<List<IWalletTransaction<T, ACCOUNT>>> _buildWalletTransaction(
      {required TRANSACTION transaction,
      required SIGNEDTX signedTx,
      required SUCCESS txId}) async {
    final txes = await buildWalletTransaction(signedTx: signedTx, txId: txId);
    for (final i in txes) {
      await account.saveTransaction(
          address: i.account, transaction: i.transaction);
    }

    return txes;
  }

  Future<void> signAndSendTransaction({BuildContext? context}) async {
    stateStatus.value = getStateStatus();
    if (stateStatus.value.status.hasError) return;
    final warning = stateStatus.value.warning;
    if (context != null && warning != null) {
      final accept = await context.openSliverDialog(
          widget: (context) => DialogTextView(text: warning));
      if (accept != true) return;
    }
    setPageProgress(text: "creating_transaction".tr);
    final result = await MethodUtils.call(() async {
      final transaction = await buildTransaction();
      setPageProgress(text: "signing_transaction_please_wait".tr);
      final signedTransaction = await signTransaction(transaction);
      setPageProgress(text: "broadcast_to_the_network_please_wait".tr);
      final result =
          await submitTransaction(signedTransaction: signedTransaction);
      return (transaction, signedTransaction, result);
    }, delay: APPConst.animationDuraion);
    if (result.hasError) {
      appLogger.error(
          runtime: runtimeType,
          functionName: "signAndSendTransaction",
          msg: result.error?.tr);

      if (result.exception == WalletExceptionConst.rejectSigning) {
        setPageIdle();
      } else {
        final error = result.error;
        setPageError(error!.tr);
      }
      return;
    }
    final submittionResult = result.result.$3;
    if (submittionResult.status.isFailed) {
      final error = (submittionResult as SubmitTransactionFailed).error;
      appLogger.error(
          runtime: runtimeType,
          functionName: "signAndSendTransaction",
          msg: error);
      setPageError(error.tr);
      return;
    }
    final successResult = result.result.$3 as SUCCESS;
    final walletTx = await _buildWalletTransaction(
        transaction: result.result.$1,
        signedTx: result.result.$2,
        txId: successResult);

    if (walletTx.isEmpty) {
      setPageIdle();
      return;
    }
    final currentTx = walletTx.firstWhere((e) => e.account == address,
        orElse: () => walletTx.first);

    setTxComplete(
        signedTx: result.result.$2,
        transaction: currentTx.transaction,
        txId: successResult,
        account: account);
  }

  void onStateUpdated() {
    final status = getStateStatus();
    stateStatus.value = status;
  }

  Widget onPageBuilder(BuildContext context) {
    return APPStreamBuilder(
        value: notifier, builder: (context, value) => widgetBuilder(context));
  }

  Future<void> init() async {
    final init = await MethodUtils.call(() async {
      _client = await account.client();
      await initForm(_client);
      onStateUpdated();
      estimateFee();
    });
    if (init.hasError) {
      appLogger.error(
          runtime: runtimeType,
          functionName: "init",
          msg: init.error,
          trace: init.trace);
      setPageError(init.error!.tr, backToIdle: false, showBackButton: false);
      return;
    }
    setPageIdle();
  }

  bool get fieldsReady => fieldsError == null;
  String? get fieldsError {
    for (final i in fields) {
      final fieldError = i.validate;
      if (fieldError != null) return fieldError;
    }
    return null;
  }

  bool get fieldsFiled {
    for (final i in fields) {
      final filed = i.complete;
      if (!filed) return false;
    }
    return true;
  }

  List<LiveFormField> get fields;
  @override
  void dispose() {
    super.dispose();
    _accountListener?.cancel();
    _feeListener?.cancel();
    for (final i in fields) {
      i.dispose();
    }
    appLogger.debug(
        functionName: "dispose",
        runtime: runtimeType,
        msg: "TransactionStateController");
  }
}
