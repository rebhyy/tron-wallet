import 'package:on_chain_wallet/app/core.dart';

typedef ONFETCHCACHEDOBJECT<T extends Object?> = Future<T> Function();

typedef ONFETCHEDCACHEDOBJECT<T extends Object?> = T Function();

class CachedObject<T extends Object?> with Equatable {
  final _lock = SynchronizedLock();
  final Duration interval;
  T? _value;
  T? get value => _value;
  DateTime? _update;
  CachedObject({this.interval = const Duration(minutes: 10)});

  bool _shouldFetch({Duration? interval}) {
    interval ??= this.interval;
    final update = _update;
    if (update == null) return true;
    final expire = update.add(interval);
    if (expire.isBefore(DateTime.now())) {
      return true;
    }
    return false;
  }

  Future<T> get(
      {required ONFETCHCACHEDOBJECT<T> onFetch, Duration? cachedTimeout}) {
    return _lock.synchronized(() async {
      final fetch = _shouldFetch(interval: cachedTimeout);
      if (!fetch) return _value as T;
      _value = null;
      _value = await onFetch();
      _update = DateTime.now();
      return _value as T;
    });
  }

  @override
  List get variabels => [interval, value];
}

class OnceRunner<T extends Object?> {
  final SynchronizedLock _lock = SynchronizedLock();
  bool _isReady = false;
  OnceRunner();

  Future<T> get(
      {required ONFETCHCACHEDOBJECT<T> onFetch,
      required ONFETCHEDCACHEDOBJECT<T> onFetched,
      Duration? cachedTimeout}) async {
    if (_isReady) return onFetched();
    return await _lock.synchronized(() async {
      final fetch = _isReady;
      if (fetch) return onFetched();
      final result = await onFetch();
      _isReady = true;
      return result;
    });
  }
}
