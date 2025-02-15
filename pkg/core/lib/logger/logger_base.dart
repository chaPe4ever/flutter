/// Logger interface
abstract interface class LoggerBase {
  /// Log Verbose
  void t(String message, {dynamic e, StackTrace? st});

  /// Log Debug
  void d(String message, {dynamic e, StackTrace? st});

  /// Log Info
  void i(String message, {dynamic e, StackTrace? st});

  /// Log Warning
  void w(String message, {dynamic e, StackTrace? st});

  /// Log Error
  void e(String message, {dynamic e, StackTrace? st});
}
