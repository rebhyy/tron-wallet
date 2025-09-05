import 'dart:async';
import 'package:on_chain_wallet/app/core.dart';

typedef FuncWalletLockTime = int? Function();

class WalletTimeoutListener {
  WalletTimeoutListener(this._onTimer, this._onLockTime);
  bool get disposed => _timer == null;

  void start() {
    final int? locktime = _onLockTime();
    if (locktime == null) return;
    _setupTimer(locktime);
  }

  StreamSubscription<int>? _timer;
  final DynamicVoid _onTimer;
  final FuncWalletLockTime _onLockTime;
  int _tick = 0;

  int? get remining {
    if (_tick <= 0) return null;
    return _tick;
  }

  void _onListenTimer(int _) {
    _tick--;
    if (_tick <= 0) {
      final lock = _onLockTime();
      if (lock != null) {
        assert(_tick <= 0);
        _onTimer();
      }
    }
  }

  StreamSubscription<int> _buildTimer(int t) {
    return Stream<int>.periodic(
      Duration(seconds: 1),
      (computationCount) => computationCount,
    ).listen(_onListenTimer, onDone: () => dispose());
  }

  void _setupTimer(int lockTime) {
    _tick = lockTime;
    if (_timer != null) return;
    assert(_timer == null);
    _timer = _buildTimer(lockTime);
  }

  void dispose() {
    _timer?.cancel().catchError((_) {});
    _timer = null;
    _tick = 0;
    Logg.log("disposed!");
  }
}
// import 'dart:async';
// import 'package:on_chain_wallet/app/core.dart';

// typedef FuncWalletLockTime = int? Function();

// class WalletTimeoutListener {
//   WalletTimeoutListener(this._onTimer, this._onLockTime);
//   bool get disposed => _timer == null;

//   void start() {
//     final int? locktime = _onLockTime();
//     if (locktime == null) return;
//     if (locktime <= 0) {
//       _onTimer();
//       return;
//     }
//     _setupTimer(locktime);
//   }

//   void stop() {
//     _stopTimer();
//   }

//   StreamSubscription<int>? _timer;
//   final DynamicVoid _onTimer;
//   final FuncWalletLockTime _onLockTime;
//   int _tick = 0;

//   int? get remining {
//     if (_tick <= 0) return null;
//     return _tick;
//   }

//   void _onListenTimer(int tick) {
//     _tick--;
//   }

//   StreamSubscription<int> _buildTimer(int t) {
//     return Stream<int>.periodic(
//       Duration(seconds: 1),
//       (computationCount) => computationCount,
//     ).take(t).listen(_onListenTimer, onDone: _onTimer);
//   }

//   void _setupTimer(int lockTime) {
//     _stopTimer();
//     _tick = lockTime;
//     Logg.log("start timer ${_timer}");
//     assert(_timer == null);
//     _timer = _buildTimer(lockTime);
//   }

//   void _stopTimer() {
//     _timer?.cancel();
//     _timer = null;
//     _tick = 0;
//   }
// }
