import 'dart:async';

import 'package:flutter/foundation.dart';

/// Local storage interface
abstract interface class LocalStorageBase {
  /// Given a [key] save the [value] you want locally
  Future<void> write(String key, dynamic value);

  /// Get any saved data locally given a [key]
  /// It returns null if nothing has been saved to this key yet
  Future<T?> read<T>(String key);

  /// Remove any locally saved data for the provided [key]
  Future<void> remove(String key);

  /// clear all data on your container, means all local data saved will be
  /// erased
  Future<void> erase();

  /// Listen to any change for a given [key]
  VoidCallback listenKey(String key, ValueSetter<dynamic> callback);
}
