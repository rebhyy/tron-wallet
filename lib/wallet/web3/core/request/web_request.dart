import 'dart:async';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/exception/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/messages/types/message.dart';
import 'package:on_chain_wallet/wallet/web3/core/permission/permission.dart';
import 'params.dart';

enum Web3RequestCompleterEventType {
  response,
  error,

  closed,
  success;

  bool get canUpdate {
    switch (this) {
      case response:
      case error:
        return true;
      default:
        return false;
    }
  }

  bool get isDone => !canUpdate;
  bool get isSuccess => this == success;
}

class Web3RequestCompleterEvent {
  final Web3RequestCompleterEventType type;
  final String? message;
  const Web3RequestCompleterEvent({required this.type, this.message});
}

abstract class Web3RequestInformation with Equatable {
  final Web3ClientInfo? client;
  Web3RequestInformation({this.client});
  bool get isClosed => _controller.isClosed;
  Stream<Web3RequestCompleterEvent> get stream =>
      _controller.stream.asBroadcastStream();
  bool get hasListener => _controller.hasListener;
  late final StreamController<Web3RequestCompleterEvent> _controller =
      StreamController<Web3RequestCompleterEvent>.broadcast(sync: true);

  final Completer<Object?> _completer = Completer();
  bool _responseHasListener = false;

  Completer<Object?>? _getResponseCompleter() {
    if (_completer.isCompleted || _responseHasListener) return null;
    try {
      return _completer;
    } finally {
      _responseHasListener = true;
    }
  }

  void _completeResponse(Object? response) {
    assert(!_completer.isCompleted, "request already completed");
    if (_completer.isCompleted) return;
    _completer.complete(response);
    final event =
        Web3RequestCompleterEvent(type: Web3RequestCompleterEventType.response);
    _controller.add(event);
  }

  void _errorResponse(
      {Object error = Web3RequestExceptionConst.rejectedByUser}) {
    assert(!_completer.isCompleted, "request already completed");
    if (_completer.isCompleted) return;
    _completer.completeError(error is Web3RequestException
        ? error
        : Web3RequestExceptionConst.fromException(error));
    final event =
        Web3RequestCompleterEvent(type: Web3RequestCompleterEventType.error);
    _controller.add(event);
  }

  void completeError({AppException? error}) {
    final event = Web3RequestCompleterEvent(
        type: Web3RequestCompleterEventType.closed, message: error?.message);
    _controller.add(event);
    _controller.close();
    if (!_completer.isCompleted && _responseHasListener) {
      _completer.completeError(error ?? Web3RequestClosed.instance);
    }
  }

  void completeSuccess() {
    final event =
        Web3RequestCompleterEvent(type: Web3RequestCompleterEventType.success);
    _controller.add(event);
    _controller.close();
  }

  String get requestId;
}

class Web3RequestLocalInformation extends Web3RequestInformation {
  Web3RequestLocalInformation(this.requestId);

  @override
  final String requestId;

  void completeResponse(Object? response) {
    if (_completer.isCompleted) return;
    super._completeResponse(response);
    completeSuccess();
  }

  void errorResponse(
      {Object error = Web3RequestExceptionConst.rejectedByUser}) {
    if (_completer.isCompleted) return;
    super._errorResponse(error: error);
    completeSuccess();
  }

  @override
  List get variabels => [requestId];

  // @override
  // String? get origin => null;
}

class Web3RequestApplicationInformation extends Web3RequestInformation {
  final Web3MessageCore message;
  @override
  final String requestId;
  final String applicationId;

  Web3RequestApplicationInformation._(
      {required this.requestId,
      required this.message,
      required this.applicationId,
      super.client});
  factory Web3RequestApplicationInformation(
      {required Web3MessageCore message,
      required String requestId,
      required String applicationId,
      required Web3ClientInfo client}) {
    return Web3RequestApplicationInformation._(
        message: message,
        requestId: requestId,
        applicationId: applicationId,
        client: client);
  }

  @override
  List get variabels => [applicationId, requestId];
}

class Web3RequestWalletConnectApplicationInformation
    extends Web3RequestInformation {
  final Web3ClientInfo info;
  final Web3MessageCore request;
  @override
  final String requestId;
  Web3RequestWalletConnectApplicationInformation._(
      {required this.info,
      required this.request,
      required this.requestId,
      required super.client});
  factory Web3RequestWalletConnectApplicationInformation(
      {required Web3ClientInfo info,
      required Web3MessageCore request,
      required String requestId}) {
    return Web3RequestWalletConnectApplicationInformation._(
        info: info, request: request, requestId: requestId, client: info);
  }

  String get applicationId => info.identifier;

  @override
  List get variabels => [info];
}

abstract class Web3Request<RESPONSE, PARAMS extends Web3WalletRequestParams,
    AUTH extends Web3RequestAuthentication> {
  final AUTH authenticated;
  final Web3RequestInformation info;
  final PARAMS params;
  const Web3Request(
      {required this.authenticated, required this.info, required this.params});
  Web3AccountAcitvity createActivity() {
    return Web3AccountAcitvity(
        method: params.method.name,
        path: info.client?.url,
        requestId: info.requestId);
  }

  void completeResponse(RESPONSE response) {
    info._completeResponse(response);
  }

  void error(Object message) {
    info._errorResponse(error: message);
  }

  void onPopRequestPage() {
    if (info._completer.isCompleted || !info._responseHasListener) return;
    info._errorResponse();
  }

  Future<RESPONSE> getResponse() async {
    final completer = info._getResponseCompleter();
    if (info.isClosed) {
      throw Web3RequestClosed.instance;
    }
    assert(completer != null, "response has already listener.");
    final result = await completer?.future;
    return result as RESPONSE;
  }
}

enum Web3NetworkRequestMode {
  silent,
}

abstract class Web3NetworkRequest<
        RESPONSE,
        NETWORKADDRESS,
        CHAIN extends Chain,
        CHANACCOUNT extends Web3ChainAccount,
        WALLETACCOUNT extends NETWORKCHAINACCOUNT,
        PARAMS extends Web3RequestParams<RESPONSE, NETWORKADDRESS, CHAIN,
            WALLETACCOUNT, CHANACCOUNT>>
    extends Web3Request<RESPONSE, PARAMS, Web3RequestAuthentication> {
  Web3NetworkRequest(
      {required super.params,
      required super.authenticated,
      required this.chain,
      required super.info,
      required List<WALLETACCOUNT> accounts})
      : accounts = accounts.imutable;

  final CHAIN chain;
  final List<WALLETACCOUNT> accounts;

  @override
  Web3AccountAcitvity createActivity() {
    final address = params.requiredAccounts.firstOrNull;
    return Web3AccountAcitvity(
        method: params.method.name,
        path: info.client?.url,
        address: address?.addressStr,
        id: chain.network.value,
        requestId: info.requestId);
  }
}
