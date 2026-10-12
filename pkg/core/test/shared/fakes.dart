import 'package:core/contracts/api_auth_strategy.dart';
import 'package:core/logger/logger_base.dart';
import 'package:core/storage/local_storage_base.dart';
import 'package:flutter/foundation.dart';

/// In-memory [LocalStorageBase] for unit tests.
final class FakeLocalStorage implements LocalStorageBase {
  final Map<String, dynamic> _store = {};
  final Map<String, List<ValueSetter<dynamic>>> _listeners = {};

  @override
  Future<void> erase() async {
    _store.clear();
  }

  @override
  VoidCallback listenKey(String key, ValueSetter<dynamic> callback) {
    _listeners.putIfAbsent(key, () => []).add(callback);
    return () {
      _listeners[key]?.remove(callback);
    };
  }

  @override
  Future<T?> read<T>(String key) async => _store[key] as T?;

  @override
  Future<void> remove(String key) async {
    _store.remove(key);
    _notify(key, null);
  }

  @override
  Future<void> write(String key, dynamic value) async {
    _store[key] = value;
    _notify(key, value);
  }

  void _notify(String key, dynamic value) {
    for (final listener in _listeners[key] ?? <ValueSetter<dynamic>>[]) {
      listener(value);
    }
  }
}

/// Captures log calls for assertions.
final class FakeLogger implements LoggerBase {
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

/// Returns a fixed access token from [getAccessToken].
final class FakeApiAuthStrategy implements ApiAuthStrategy {
  FakeApiAuthStrategy(this.token);

  final String token;

  @override
  Future<String> getAccessToken() async => token;
}
