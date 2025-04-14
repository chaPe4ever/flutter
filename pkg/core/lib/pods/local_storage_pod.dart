import 'package:core/core.dart';
import 'package:core/storage/local_storage_shared_prefs_impl.dart';
import 'package:flutter/foundation.dart';

part 'local_storage_pod.g.dart';

/// Defines which storage implementation to use
enum StorageType { getStorage, sharedPreferences }

/// Local storage pod that provides storage functionality
@riverpod
class LocalStorage extends _$LocalStorage {
  @override
  LocalStorageBase build() {
    return LocalStorageSharedPreferenceImpl();
  }

  /// Read a value from storage
  Future<T?> read<T>(String key) {
    return state.read<T>(key);
  }

  /// Write a value to storage
  Future<void> write(String key, dynamic value) async {
    return state.write(key, value);
  }

  /// Remove a value from storage
  Future<void> remove(String key) async {
    return state.remove(key);
  }

  /// Clear all storage
  Future<void> erase() async {
    return state.erase();
  }

  /// Add a listener for a specific key
  VoidCallback listenKey(String key, ValueSetter<dynamic> callback) {
    return state.listenKey(key, callback);
  }
}
