import 'dart:async';

import 'package:flutter/material.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/future.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/types/types.dart';
import 'package:on_chain_wallet/wallet/api/client/core/client.dart';
import 'package:on_chain_wallet/wallet/models/models.dart';
import 'package:on_chain_wallet/wallet/web3/web3.dart';

class Web3RequestTransactionResponseData<RESPONSE,
        SUCCESS extends SubmitTransactionSuccess>
    extends Web3RequestResponseData<RESPONSE> {
  final List<SubmitTransactionResult>? txIds;
  Web3RequestTransactionResponseData(
      {required super.response, super.message, this.txIds});
  factory Web3RequestTransactionResponseData.submitTx(
      {required RESPONSE response,
      required List<SubmitTransactionResult> txIds}) {
    assert(txIds.isNotEmpty);
    return Web3RequestTransactionResponseData(
        response: response, txIds: txIds.isEmpty ? null : txIds);
  }
}

abstract class Web3TransactionStateController<
        RESPONSE,
        NETWORKADDRESS,
        ACCOUNT extends NETWORKCHAINACCOUNT<NETWORKADDRESS>,
        CLIENT extends NetworkClient,
        OUTCLIENT extends CLIENT?,
        NETWORK extends WalletNetwork,
        C extends APPCHAINADDRESSACCOUNTCLIENTNETWORK<NETWORKADDRESS, ACCOUNT,
            CLIENT, NETWORK>,
        CHANACCOUNT extends Web3ChainAccount,
        WEB3CHAIN extends Web3Chain<NETWORKADDRESS, C, ACCOUNT, CHANACCOUNT,
            WalletNetwork>,
        PARAMS extends Web3RequestParams<RESPONSE, NETWORKADDRESS, C, ACCOUNT,
            CHANACCOUNT, WEB3CHAIN>,
        WEB3REQUEST extends Web3NetworkRequest<RESPONSE, NETWORKADDRESS, C,
            CHANACCOUNT, ACCOUNT, WEB3CHAIN, PARAMS>,
        TRANSACTIONDATA extends ITransactionData,
        TRANSACTION extends ITransaction<TRANSACTIONDATA, ACCOUNT>,
        SIGNEDTX extends ISignedTransaction<TRANSACTION, Object>,
        T extends ChainTransaction,
        SUCCESS extends SubmitTransactionSuccess<SIGNEDTX>>
    extends Web3StateController<
        RESPONSE,
        NETWORKADDRESS,
        NETWORK,
        CLIENT,
        OUTCLIENT,
        ACCOUNT,
        C,
        CHANACCOUNT,
        WEB3CHAIN,
        PARAMS,
        WEB3REQUEST,
        Web3RequestTransactionResponseData<RESPONSE, SUCCESS>,
        T> {
  Web3TransactionStateController(
      {required super.walletProvider, required super.request});

  List<StreamSubscription<IntegerBalance>> _listeners = [];

  Future<TRANSACTIONDATA> buildTransactionData({bool simulate = false});
  Future<TRANSACTION> buildTransaction({bool simulate = false});
  Future<SIGNEDTX> signTransaction(TRANSACTION transaction,
      {bool fakeSignature = false});
  Future<SubmitTransactionResult> submitTransaction(
      {required SIGNEDTX signedTransaction});
  Future<List<IWalletTransaction<T, ACCOUNT>>> buildWalletTransaction(
      {required SIGNEDTX signedTx, required SUCCESS? txId});

  WalletWeb3ClientTransaction web3ClientInfo() {
    return WalletWeb3ClientTransaction(
        name: request.info.client?.name ?? request.authenticated.name,
        applicationId: request.authenticated.applicationId,
        image: request.info.client?.image ?? request.authenticated.icon);
  }

  Future<SUCCESS> buildSignAndSendTransaction() async {
    final transaction = await buildTransaction();
    final signedTransaction = await signTransaction(transaction);
    final txId = await submitTransaction(signedTransaction: signedTransaction);
    appLogger.debug(
        runtime: runtimeType,
        functionName: "buildSignAndSendTransaction",
        msg: txId);
    if (txId.status.isFailed) {
      final error = txId.cast<SubmitTransactionFailed>();
      throw Web3RequestExceptionConst.excuteTransactionFailed(error.error);
    }
    return txId.cast<SUCCESS>();
  }

  void onAccountUpdated(ACCOUNT e) {}

  // Future<void> initForm() {}
  @override
  Future<void> initForm(OUTCLIENT client) async {
    for (final i in accounts) {
      final sub = i.address.balance.stream.listen((e) => onAccountUpdated(i));
      _listeners.add(sub);
    }
    await super.initForm(client);
    account.updateAccountBalance(addresses: accounts);
  }

  @override
  Future<void> acceptRequest({BuildContext? context}) async {
    try {
      if (!stateStatus.value.isReady) return;
      final warning = stateStatus.value.warning;
      if (context != null && warning != null) {
        final accept = await context.openSliverDialog(
            widget: (context) => DialogTextView(
                  text: warning,
                  buttonWidget: DialogDoubleButtonView(),
                ));
        if (accept != true) return;
      }
      pageKey.processs(text: "processing_request".tr);
      final response = await getResponse();
      request.completeResponse(response.response);
      final txIds = response.txIds;
      if (txIds != null) {
        for (final i in txIds) {
          if (i.status.isFailed) continue;
          final successResult = i.cast<SUCCESS>();
          final walletTxes = await buildWalletTransaction(
              signedTx: successResult.signedTransaction, txId: successResult);
          for (final i in walletTxes) {
            await account.saveTransaction(
                address: i.account, transaction: i.transaction);
          }
          appLogger.debug(
              runtime: runtimeType,
              functionName: "submit transaction",
              msg: successResult.txId);
        }
        pageKey.responseTx(txIds: txIds, account: account);
      } else {
        pageKey.response(text: response.message);
      }

      appLogger.debug(
          runtime: runtimeType, functionName: "acceptRequest", msg: response);
    } on Web3RequestException catch (e, s) {
      pageKey.errorResponse(error: e);
      request.error(e);
      appLogger.error(
          runtime: runtimeType,
          functionName: "acceptRequest",
          msg: e,
          trace: s);
    } on Web3InternalError catch (e, s) {
      pageKey.error(error: e, showBackButton: true);
      appLogger.error(
          runtime: runtimeType,
          functionName: "acceptRequest",
          msg: e,
          trace: s);
    } on WalletException catch (e, s) {
      pageKey.error(error: e, showBackButton: true);
      appLogger.error(
          runtime: runtimeType,
          functionName: "acceptRequest",
          msg: e,
          trace: s);
    } catch (e, s) {
      if (e == WalletExceptionConst.rejectSigning) {
        pageKey.error(error: e, showBackButton: true);
        return;
      }
      appLogger.error(
          runtime: runtimeType,
          functionName: "acceptRequest",
          msg: e,
          trace: s);
      final exception = Web3RequestExceptionConst.fromException(e);
      pageKey.errorResponse(error: exception);
      request.error(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (final i in [..._listeners]) {
      i.cancel();
    }
    _listeners = [];
  }
}
