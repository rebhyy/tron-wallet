import 'dart:async';
import 'package:flutter/material.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/web3/web3.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';
import 'package:on_chain_wallet/wallet/web3/web3.dart';

abstract class Web3StateContoller<WEB3REQUEST extends Web3Request>
    extends StateController {
  WEB3REQUEST get request;
  ChainAccount? get permissionAccount;

  final GlobalKey<Web3PageProgressState> progressKey =
      GlobalKey<Web3PageProgressState>();
  StreamSubscription<dynamic>? onRequestError;
  Future<void> initWeb3();
  bool get web3Closed => request.info.isClosed;

  void _onChangeStatus(Web3RequestCompleterEvent event) {
    switch (event.type) {
      case Web3RequestCompleterEventType.success:
        progressKey.successRequest();
        break;
      case Web3RequestCompleterEventType.closed:
        progressKey.closedRequest(error: event.message);
        break;
      default:
    }
  }

  @override
  void close() {
    onRequestError?.cancel();
    onRequestError = null;
    super.close();
  }
}

mixin Web3GlobalRequestControllerState<WEB3REQUEST extends Web3GlobalRequest>
    on Web3StateContoller<WEB3REQUEST> {
  @override
  ChainAccount? get permissionAccount => null;
  Future<void> _readyWeb3() async {
    notify();
    final isReady = await MethodUtils.after(() async => _init());
    if (isReady) {
      final r = await MethodUtils.call(() => initWeb3());
      if (r.hasError) {
        progressKey.errorResponse(error: r.exception);
        final error = Web3RequestExceptionConst.fromException(r.exception!);
        request.error(error);
      }
    }
  }

  Future<bool> _init() async {
    if (web3Closed) {
      progressKey.closedRequest();
    } else {
      onRequestError = request.info.stream.listen(_onChangeStatus);
      return true;
    }

    return false;
  }

  @override
  void ready() {
    super.ready();
    _readyWeb3();
  }
}
