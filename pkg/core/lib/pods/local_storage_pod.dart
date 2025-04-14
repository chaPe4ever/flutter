import 'package:core/core.dart';
import 'package:core/storage/local_storage_get_impl.dart';
import 'package:core/storage/local_storage_shared_prefs_impl.dart';
import 'package:flutter/foundation.dart';

part 'local_storage_pod.g.dart';

/// Defines which storage implementation to use
enum StorageType { getStorage, sharedPreferences }

/// Local storage pod that provides storage functionality
@Riverpod(keepAlive: true)
class LocalStorage extends _$LocalStorage {
  @override
  FutureOr<LocalStorageBase?> build() {
    return Future.microtask(() {
      return null;
    });
  }

  Future<void> init({required StorageType type}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return switch (type) {
        StorageType.getStorage => await _initGetStorage(),
        StorageType.sharedPreferences => await _initSharedPreferences(),
      };
    });
  }

  /// Initialize GetStorage implementation
  Future<LocalStorageBase> _initGetStorage() async {
    if (!await GetStorage.init()) {
      const msg = "GetStorage.init() couldn't be initialized";
      throw const StorageInitialisationException(innerMessage: msg);
    }
    return LocalStorageGetImpl();
  }

  /// Initialize SharedPreferences implementation
  Future<LocalStorageBase> _initSharedPreferences() async {
    return LocalStorageSharedPreferenceImpl();
  }

  /// Get the local storage instance
  LocalStorageBase get requireValue =>
      state.valueOrNull == null
          ? throw const StorageInitialisationException()
          : state.requireValue!;

  /// Check if storage is initialized
  bool get hasValue => state.hasValue;

  /// Check if storage has an error
  bool get hasError => state.hasError;

  // ---- Direct storage methods ----

  /// Read a value from storage
  Future<T?> read<T>(String key) {
    if (!hasValue) return Future.value();
    return requireValue.read<T>(key);
  }

  /// Write a value to storage
  Future<void> write(String key, dynamic value) async {
    if (!hasValue) {
      throw const StorageInitialisationException(
        innerMessage: 'Local storage not initialized. Call init() first.',
      );
    }
    return requireValue.write(key, value);
  }

  /// Remove a value from storage
  Future<void> remove(String key) async {
    if (!hasValue) return;
    return requireValue.remove(key);
  }

  /// Clear all storage
  Future<void> erase() async {
    if (!hasValue) return;
    return requireValue.erase();
  }

  /// Add a listener for a specific key
  VoidCallback listenKey(String key, ValueSetter<dynamic> callback) {
    if (!hasValue) {
      throw const StorageInitialisationException(
        innerMessage: 'Local storage not initialized. Call init() first.',
      );
    }
    return requireValue.listenKey(key, callback);
  }
}
