import 'package:core/logger/logger_base.dart';
import 'package:logger/logger.dart';

/// Logger implementation
class LoggerImpl implements LoggerBase {
  /// Constructor
  const LoggerImpl({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  void t(String message, {dynamic e, StackTrace? st}) => _logger.t(
        message,
        error: e,
        stackTrace: st ?? StackTrace.current,
      );

  @override
  void d(String message, {dynamic e, StackTrace? st}) => _logger.d(
        message,
        error: e,
        stackTrace: st ?? StackTrace.current,
      );
  @override
  void i(String message, {dynamic e, StackTrace? st}) => _logger.i(
        message,
        error: e,
        stackTrace: st ?? StackTrace.empty,
      );
  @override
  void w(String message, {dynamic e, StackTrace? st}) => _logger.w(
        message,
        error: e,
        stackTrace: st ?? StackTrace.current,
      );
  @override
  void e(String message, {dynamic e, StackTrace? st}) => _logger.e(
        message,
        error: e,
        stackTrace: st ?? StackTrace.current,
      );
}
