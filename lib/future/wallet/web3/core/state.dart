import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/controller/controller.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/web3/core/exception.dart';
import 'package:on_chain_wallet/future/wallet/web3/pages/widgets/parogress.dart';
import 'package:on_chain_wallet/wallet/api/client/core/client.dart';
import 'package:on_chain_wallet/wallet/models/models.dart';
import 'package:on_chain_wallet/wallet/web3/web3.dart';

mixin Web3StatePageController<WEB3REQUEST extends Web3Request>
    on StreamStateController {
  WEB3REQUEST get request;

  Widget widgetBuilder(BuildContext context);
  Widget onPageBuilder(BuildContext context) {
    return APPStreamBuilder(
        value: notifier, builder: (context, value) => widgetBuilder(context));
  }

  bool get web3Closed => request.info.isClosed;
  StreamWeb3PageProgressController pageKey = StreamWeb3PageProgressController(
      initialStatus: Web3ProgressStatus.progress);
  StreamSubscription<dynamic>? _listener;

  void _onChangeStatus(Web3RequestCompleterEvent event) {
    switch (event.type) {
      case Web3RequestCompleterEventType.success:
        pageKey.successRequest();
        break;
      case Web3RequestCompleterEventType.closed:
        pageKey.closedRequest(error: event.message);
        break;
      default:
    }
  }

  void setPageProgress(String text) {
    pageKey.processs(text: text);
  }

  void setPageError(Object error) {
    pageKey.error(error: error, showBackButton: true);
  }

  @override
  void dispose() {
    _listener?.cancel();
    _listener = null;
    pageKey.dispose();
    super.dispose();
    appLogger.debug(
        runtime: runtimeType,
        functionName: "dispose",
        msg: "Web3StatePageController");
  }
}

abstract class BaseWeb3StateController<WALLETACCOUNT extends ChainAccount> {
  WalletProvider get walletProvider;
  List<WALLETACCOUNT> get accounts;
  StreamValue<TransactionStateStatus> get stateStatus;
  StreamWeb3PageProgressController get pageKey;
  void onStateUpdated();
  Widget onPageBuilder(BuildContext context);
  Future<void> init();
  TransactionStateStatus getStateStatus();
  Future<void> acceptRequest({BuildContext? context});
  void dispose();
  bool get showRequestAccount;
}

class Web3RequestResponseData<RESPONSE> {
  final RESPONSE response;
  final String? message;
  Web3RequestResponseData._(
      {required this.response,
      List<SubmitTransactionResult>? txIds,
      this.message});
  Web3RequestResponseData({required this.response, this.message});
  factory Web3RequestResponseData.submitTx(
      {required RESPONSE response,
      required List<SubmitTransactionResult> txIds}) {
    assert(txIds.isNotEmpty);
    return Web3RequestResponseData._(
        response: response, txIds: txIds.isEmpty ? null : txIds);
  }
}

enum Web3SecurityLevel {
  minimal, // informational or non-critical actions
  standard, // typical transactions
  critical, // permission changes, key management
}

abstract class Web3StateController<
        RESPONSE,
        NETWORKADDRESS,
        NETWORK extends WalletNetwork,
        CLIENT extends NetworkClient,
        OUTCLIENT extends CLIENT?,
        WALLETACCOUNT extends NETWORKCHAINACCOUNT<NETWORKADDRESS>,
        CHAIN extends APPCHAINADDRESSACCOUNTCLIENTNETWORK<NETWORKADDRESS,
            WALLETACCOUNT, CLIENT, NETWORK>,
        CHANACCOUNT extends Web3ChainAccount,
        WEB3CHAIN extends Web3Chain<NETWORKADDRESS, CHAIN, WALLETACCOUNT,
            CHANACCOUNT, WalletNetwork>,
        PARAMS extends Web3RequestParams<RESPONSE, NETWORKADDRESS, CHAIN,
            WALLETACCOUNT, CHANACCOUNT, WEB3CHAIN>,
        WEB3REQUEST extends Web3NetworkRequest<RESPONSE, NETWORKADDRESS, CHAIN,
            CHANACCOUNT, WALLETACCOUNT, WEB3CHAIN, PARAMS>,
        FINALRESULT extends Web3RequestResponseData<RESPONSE>,
        T extends ChainTransaction>
    with
        DisposableMixin,
        StreamStateController,
        Web3StatePageController<WEB3REQUEST>
    implements BaseWeb3StateController<WALLETACCOUNT> {
  Web3StateController({required this.walletProvider, required this.request});
  @override
  bool get showRequestAccount => true;
  Web3SecurityLevel get securityLevel => Web3SecurityLevel.minimal;
  @override
  final StreamValue<TransactionStateStatus> stateStatus =
      StreamValue(TransactionStateStatus.error());
  @override
  TransactionStateStatus getStateStatus() {
    return TransactionStateStatus.ready();
  }

  @override
  void onStateUpdated() {
    final status = getStateStatus();
    stateStatus.value = status;
  }

  CHAIN get account => request.chain;
  NETWORK get network => account.network;
  PARAMS get params => request.params;
  WALLETACCOUNT? findPermissionAccount(NETWORKADDRESS address) {
    return accounts.firstWhereOrNull((e) => e.networkAddress == address);
  }

  WALLETACCOUNT get defaultAccount {
    if (accounts.isEmpty) {
      throw Web3RequestExceptionConst.missingPermission;
    }
    return accounts.first;
  }

  ReceiptAddress<NETWORKADDRESS> getOrCreateAddressInfo(
      NETWORKADDRESS address, String viewAddress) {
    return account.getReceiptAddress(viewAddress) ??
        ReceiptAddress<NETWORKADDRESS>(
            networkAddress: address, view: viewAddress);
  }

  CHANACCOUNT? getWeb3Account(NETWORKADDRESS address) {
    return web3Accounts.firstWhereOrNull((e) => e.address == address);
  }

  @override
  final WalletProvider walletProvider;
  @override
  final WEB3REQUEST request;

  late final OUTCLIENT client;

  @override
  List<WALLETACCOUNT> get accounts => request.accounts;
  List<CHANACCOUNT> get web3Accounts => request.params.requiredAccounts;
  Future<OUTCLIENT> _client() async {
    if (null is OUTCLIENT) {
      return null as OUTCLIENT;
    }
    final client = await account.client();
    return client as OUTCLIENT;
  }

  Future<FINALRESULT> getResponse();
  Future<void> initForm(OUTCLIENT client) async {}
  @override
  Future<void> init() async {
    if (web3Closed) {
      pageKey.closedRequest();
      return;
    }
    _listener = request.info.stream.listen(_onChangeStatus);
    try {
      client = await _client();
      await initForm(client);
      onStateUpdated();
      pageKey.idle();
    } catch (e) {
      pageKey.errorResponse(error: e);
      request.error(e);
      appLogger.error(runtime: runtimeType, functionName: "init", msg: e);
    }
  }

  @override
  Future<void> acceptRequest({BuildContext? context}) async {
    try {
      pageKey.processs(text: "processing_request".tr);
      final response = await getResponse();
      request.completeResponse(response.response);
      pageKey.response();
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
      final exception = Web3RequestExceptionConst.fromException(e);
      pageKey.errorResponse(error: exception);
      request.error(e);
      appLogger.error(
          runtime: runtimeType,
          functionName: "acceptRequest",
          msg: e,
          trace: s);
    }
  }

  @override
  void dispose() {
    super.dispose();
    stateStatus.dispose();
    appLogger.debug(runtime: runtimeType, functionName: "Web3StateController");
  }
}
