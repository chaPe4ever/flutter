import 'package:core/core.dart';
import 'package:core/storage/local_storage_get_impl.dart';
import 'package:core/storage/local_storage_shared_prefs_impl.dart';
import 'package:flutter/foundation.dart';

part 'local_storage_pod.g.dart';

/// Defines which storage implementation to use
enum StorageType { getStorage, sharedPreferences }

/// Initialization state for the storage provider
sealed class LocalStorageState {
  const LocalStorageState();
}

/// Storage service is not initialized yet
final class UninitializedState extends LocalStorageState {
  const UninitializedState();
}

/// Storage service is being initialized
final class InitializingState extends LocalStorageState {
  const InitializingState();
}

/// Storage service is initialized and ready to use
final class InitializedState extends LocalStorageState {
  const InitializedState(this.storage);
  final LocalStorageBase storage;
}

/// Storage service failed to initialize
final class ErrorState extends LocalStorageState {
  const ErrorState(this.error);
  final CoreException error;
}

/// Local storage pod that provides storage functionality
@Riverpod(keepAlive: true)
class LocalStorage extends _$LocalStorage {
  @override
  LocalStorageState build() {
    // Start in uninitialized state
    return const UninitializedState();
  }

  /// Initialize the local storage with the specified implementation
  Future<void> init(StorageType type) async {
    // Skip if already initialized or initializing
    if (state is InitializedState || state is InitializingState) return;

    // Set initializing state
    state = const InitializingState();

    try {
      final storageImpl = switch (type) {
        StorageType.getStorage => await _initGetStorage(),
        StorageType.sharedPreferences => await _initSharedPreferences(),
      };

      // Set initialized state with the implementation
      state = InitializedState(storageImpl);
    } catch (e) {
      final exception = e is CoreException ? e : e.toCoreException();
      state = ErrorState(exception);
      throw exception;
    }
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
  LocalStorageBase get requireValue => switch (state) {
    InitializedState(storage: final storage) => storage,
    UninitializedState() =>
      throw const StorageInitialisationException(
        innerMessage: 'Local storage not initialized. Call init() first.',
      ),
    InitializingState() =>
      throw const StorageInitialisationException(
        innerMessage: 'Local storage initialization in progress.',
      ),
    ErrorState(error: final error) => throw error,
  };

  /// Check if storage is initialized
  bool get hasValue => state is InitializedState;

  /// Check if storage has an error
  bool get hasError => state is ErrorState;

  /// Get error if present
  CoreException? get error => switch (state) {
    ErrorState(error: final err) => err,
    _ => null,
  };

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
