import 'dart:async';

import 'package:core/storage/local_storage_base.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local storage implementation using SharedPreferences
final class LocalStorageSharedPreferenceImpl implements LocalStorageBase {
  // Map to store listeners by key
  final Map<String, List<ValueSetter<dynamic>>> _listeners = {};

  @override
  Future<void> erase() async {
    await SharedPreferencesAsync().clear();
  }

  @override
  VoidCallback listenKey(String key, ValueSetter<dynamic> callback) {
    if (!_listeners.containsKey(key)) {
      _listeners[key] = [];
    }
    _listeners[key]!.add(callback);

    // Return a function that removes this listener when called
    return () {
      if (_listeners.containsKey(key)) {
        _listeners[key]!.remove(callback);
        if (_listeners[key]!.isEmpty) {
          _listeners.remove(key);
        }
      }
    };
  }

  @override
  Future<T?> read<T>(String key) {
    if (T == String) {
      return Future.value(SharedPreferencesAsync().getString(key) as T?);
    } else if (T == int) {
      return Future.value(SharedPreferencesAsync().getInt(key) as T?);
    } else if (T == bool) {
      return Future.value(SharedPreferencesAsync().getBool(key) as T?);
    } else if (T == double) {
      return Future.value(SharedPreferencesAsync().getDouble(key) as T?);
    } else if (T == List<String>) {
      return Future.value(SharedPreferencesAsync().getStringList(key) as T?);
    }

    return Future.value();
  }

  @override
  Future<void> remove(String key) async {
    await SharedPreferencesAsync().remove(key);
    _notifyListeners(key, null);
  }

  @override
  Future<void> write(String key, dynamic value) async {
    if (value is String) {
      await SharedPreferencesAsync().setString(key, value);
    } else if (value is int) {
      await SharedPreferencesAsync().setInt(key, value);
    } else if (value is bool) {
      await SharedPreferencesAsync().setBool(key, value);
    } else if (value is double) {
      await SharedPreferencesAsync().setDouble(key, value);
    } else if (value is List<String>) {
      await SharedPreferencesAsync().setStringList(key, value);
    }

    _notifyListeners(key, value);
  }

  // Helper method to notify listeners when values change
  void _notifyListeners(String key, dynamic value) {
    if (_listeners.containsKey(key)) {
      for (final callback in _listeners[key]!) {
        callback(value);
      }
    }
  }
}
