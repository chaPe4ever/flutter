import 'package:core/core.dart';

/// Stacktrace extension
extension StackTraceX on StackTrace {
  static StackTraceLoggerHelper get _stLogger =>
      StackTraceLoggerHelper.from(StackTrace.current);

  /// Self explained
  static String get functionName => _stLogger.functionName;

  /// Self explained
  static String get callerFunctionName => _stLogger.callerFunctionName;

  /// Self explained
  static String get fileName => _stLogger.fileName;

  /// Self explained
  static String get lineNumber => _stLogger.lineNumber.toString();

  /// Self explained
  static String get columnNumber => _stLogger.columnNumber.toString();
}
