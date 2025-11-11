// ignore_for_file: avoid_print

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/error/exception/exception.dart';

enum LoggerMode {
  dev,
  silent;

  bool get isDev => this == dev;
}

enum LogType { debug, warning, error }

const appLogger = _APPLogger(mode: LoggerMode.silent);

typedef LOGWHEN = bool Function();

class _APPLogger {
  final LoggerMode mode;
  const _APPLogger({this.mode = LoggerMode.dev});

  void debug(
      {Object? runtime, Object? functionName, Object? msg, LOGWHEN? when}) {
    return _log(
        className: runtime?.toString(),
        functionName: functionName?.toString(),
        type: LogType.debug,
        message: msg,
        when: when);
  }

  void warn(
          {Object? runtime,
          Object? functionName,
          Object? msg,
          LOGWHEN? when}) =>
      _log(
          className: runtime?.toString(),
          functionName: functionName?.toString(),
          type: LogType.warning,
          message: msg,
          when: when);

  void error(
          {Object? runtime,
          Object? functionName,
          Object? msg,
          StackTrace? trace,
          LOGWHEN? when}) =>
      _log(
          className: runtime?.toString(),
          functionName: functionName?.toString(),
          type: LogType.error,
          message: msg,
          stackTrace: trace,
          when: when);
  void _log(
      {String? className,
      String? functionName,
      required LogType type,
      Object? message,
      StackTrace? stackTrace,
      LOGWHEN? when}) {
    assert(() {
      () {
        if (mode == LoggerMode.silent) return;
        if (when != null && !when()) return;
        final prefix = _logPrefix(type);
        final output = StringBuffer()..write(prefix);
        if (className != null || functionName != null) {
          output.write("[${className ?? ''}.${functionName ?? ''}]");
        }
        if (message != null) {
          String msg;
          if (message is List || message is Map) {
            msg = StringUtils.fromJson(message, toStringEncodable: true);
          } else {
            msg = message.toString();
          }
          output.write(" $msg");
        }

        if (type == LogType.error && stackTrace != null) {
          final String? error = switch (message) {
            final ApiProviderException _ => null,
            _ => "$stackTrace"
          };
          // final traceInfo = StackTraceInfo.parseStackTrace(stackTrace);
          if (error != null) output.writeln('\n$error');
        }
        final finalMessage = output.toString();

        switch (type) {
          case LogType.debug:
            _debug(finalMessage);
            break;
          case LogType.warning:
            _warning(finalMessage);
            return;
          case LogType.error:
            _error(finalMessage);
            break;
        }
      }();
      return true;
    }());
  }

  String _logPrefix(LogType type) {
    switch (type) {
      case LogType.debug:
        return '[DEBUG]';
      case LogType.warning:
        return '[WARNING]';
      case LogType.error:
        return '[ERROR]';
    }
  }

  static void _warning(String text) {
    const yellow = '\x1B[33m';
    const reset = '\x1B[0m';
    final coloredText =
        yellow + text.replaceAll('\n', '\x1B[0m\n\x1B[33m') + reset;
    print(coloredText);
  }

  static void _error(String text) {
    const red = '\x1B[31m';
    const reset = '\x1B[0m';
    final coloredText =
        red + text.replaceAll('\n', '\x1B[0m\n\x1B[31m') + reset;
    print(coloredText);
  }

  static void _debug(String text) {
    const green = '\x1B[32m';
    const reset = '\x1B[0m';
    final coloredText =
        green + text.replaceAll('\n', '\x1B[0m\n\x1B[32m') + reset;
    print(coloredText);
  }
}

class StackTraceInfo {
  final String filePath;
  final String function;
  final int line;
  final int column;
  static StackTraceInfo? parseStackTrace(StackTrace? stackTrace,
      {int frameIndex = 0}) {
    if (stackTrace == null) return null;
    final lines = stackTrace.toString().trim().split('\n');
    if (lines.length <= frameIndex) return null;

    final line = lines[frameIndex];

    final regex = RegExp(r'^#\d+\s+([^\s]+)\s+\((.+?):(\d+):(\d+)\)$');
    final match = regex.firstMatch(line);

    if (match != null) {
      final function = match.group(1)!;
      final filePath = match.group(2)!;
      final lineNumber = int.parse(match.group(3)!);
      final columnNumber = int.parse(match.group(4)!);

      return StackTraceInfo(
        filePath: filePath,
        function: function,
        line: lineNumber,
        column: columnNumber,
      );
    }

    return null;
  }

  const StackTraceInfo({
    required this.filePath,
    required this.function,
    required this.line,
    required this.column,
  });

  @override
  String toString() {
    return 'Function: $function\nFile: $filePath:$line:$column';
  }
}
