import 'package:core/exceptions/core_exceptions.dart';
import 'package:core/storage/local_storage_base.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

/// Local storage implementation
final class LocalStorageImpl implements LocalStorageBase {
  static var _initialised = false;

  @override
  Future<LocalStorageImpl> init() async {
    if (!_initialised) {
      _initialised = true;
      if (!await GetStorage.init()) {
        throw const StorageInitialisationException();
      }
    }
    return this;
  }

  @override
  Future<void> erase() => GetStorage().erase();

  @override
  VoidCallback listenKey(String key, ValueSetter<dynamic> callback) =>
      GetStorage().listenKey(key, callback);

  @override
  T? read<T>(String key) => GetStorage().read<T>(key);

  @override
  Future<void> remove(String key) => GetStorage().remove(key);

  @override
  Future<void> write(String key, dynamic value) =>
      GetStorage().write(key, value);
}
