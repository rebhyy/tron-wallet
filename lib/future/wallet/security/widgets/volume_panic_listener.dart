import 'package:flutter/services.dart';

typedef OnVolumePattern = Future<void> Function();

enum VolumePress { up, down }

class VolumePanicListener {
  static const List<LogicalKeyboardKey> _pattern = [
    LogicalKeyboardKey.audioVolumeUp,
    LogicalKeyboardKey.audioVolumeDown,
    LogicalKeyboardKey.audioVolumeUp
  ];
  int _index = 0;
  DateTime? _lastKey;
  final Duration window;
  final OnVolumePattern onMatch;

  VolumePanicListener(
      {required this.onMatch, this.window = const Duration(seconds: 5)});

  Future<void> handleVolume(VolumePress press) async {
    final key = press == VolumePress.up
        ? LogicalKeyboardKey.audioVolumeUp
        : LogicalKeyboardKey.audioVolumeDown;
    await _progress(key);
  }

  Future<void> _progress(LogicalKeyboardKey key) async {
    final now = DateTime.now();
    if (_lastKey != null && now.difference(_lastKey!) > window) {
      _index = 0;
    }
    _lastKey = now;
    if (key == _pattern[_index]) {
      _index += 1;
      if (_index == _pattern.length) {
        _index = 0;
        await onMatch();
        _lastKey = null;
      }
    } else {
      _index = 0;
    }
  }
}
