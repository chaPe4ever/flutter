import 'package:core/storage/local_storage_base.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

/// Local storage implementation
final class LocalStorageGetImpl implements LocalStorageBase {
  @override
  Future<void> erase() => GetStorage().erase();

  @override
  VoidCallback listenKey(String key, ValueSetter<dynamic> callback) =>
      GetStorage().listenKey(key, callback);

  @override
  Future<T?> read<T>(String key) => Future.value(GetStorage().read<T>(key));

  @override
  Future<void> remove(String key) => GetStorage().remove(key);

  @override
  Future<void> write(String key, dynamic value) =>
      GetStorage().write(key, value);
}
