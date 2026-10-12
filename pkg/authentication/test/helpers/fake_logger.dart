import 'package:core/core.dart';

class FakeLogger implements LoggerBase {
  FakeLogger();

  final List<String> debugMessages = [];
  final List<String> errorMessages = [];

  @override
  void d(String message, {dynamic e, StackTrace? st}) {
    debugMessages.add(message);
  }

  @override
  void e(String message, {dynamic e, StackTrace? st}) {
    errorMessages.add(message);
  }

  @override
  void i(String message, {dynamic e, StackTrace? st}) {}

  @override
  void t(String message, {dynamic e, StackTrace? st}) {}

  @override
  void w(String message, {dynamic e, StackTrace? st}) {}
}
