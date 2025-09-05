import 'dart:async';
import 'package:on_chain_wallet/app/error/exception/app_exception.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';

class WorkerMessageCompleter {
  final int id;
  WorkerMessageCompleter(this.id);
  final Completer<CborMessageResponseArgs> _messageCompleter = Completer();

  void complete(CborMessageResponseArgs message) {
    _messageCompleter.complete(message);
  }

  void close() {
    _messageCompleter
        .completeError(AppCryptoException("isolate_terminated_error"));
  }

  Future<CborMessageResponseArgs> getResult({Duration? timeout}) async {
    final result = await _messageCompleter.future
        .timeout(timeout ?? const Duration(seconds: 120));
    return result;
  }
}
