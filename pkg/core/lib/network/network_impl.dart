import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

/// Network connection implementation
final class NetworkImpl implements NetworkBase {
  /// Constructor
  NetworkImpl({required Connectivity connectivity})
    : _connectivity = connectivity,
      _connectionStatusController =
          StreamController<NetworkStatus>.broadcast() {
    // Initialize with current connectivity status
    _initConnectivity();

    // Listen for connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      if (results.isNotEmpty) {
        _connectionStatusController.add(getStatusFromResult(results.last));
      } else {
        _connectionStatusController.add(NetworkStatus.offline);
      }
    });
  }

  // Fields
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  final StreamController<NetworkStatus> _connectionStatusController;
  final Connectivity _connectivity;

  // Callback collections
  final Set<VoidCallback> _onlineCallbacks = {};
  final Set<VoidCallback> _offlineCallbacks = {};

  // Single subscription that notifies all callbacks
  StreamSubscription<NetworkStatus>? _statusSubscription;

  // Initialize with current connectivity status
  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isNotEmpty) {
        _connectionStatusController.add(getStatusFromResult(results.last));
      } else {
        _connectionStatusController.add(NetworkStatus.offline);
      }
    } catch (e) {
      debugPrint('Error checking initial connectivity: $e');
      _connectionStatusController.add(NetworkStatus.offline);
    }
  }

  @override
  Future<bool> get isConnected async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      return connectivityResults.any(
        (result) => result != ConnectivityResult.none,
      );
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }

  // Convert from the third part enum to our own enum
  @visibleForTesting
  NetworkStatus getStatusFromResult(ConnectivityResult result) {
    return switch (result) {
      ConnectivityResult.mobile => NetworkStatus.cellular,
      ConnectivityResult.wifi => NetworkStatus.wifi,
      ConnectivityResult.none => NetworkStatus.offline,
      ConnectivityResult.bluetooth ||
      ConnectivityResult.ethernet ||
      ConnectivityResult.vpn ||
      ConnectivityResult.other => NetworkStatus.other,
    };
  }

  @override
  void addListener({VoidCallback? onOnline, VoidCallback? onOffline}) {
    assert(
      onOnline != null || onOffline != null,
      'At least one of onOnline or onOffline must be provided',
    );

    // Add callbacks to appropriate sets
    if (onOnline != null) _onlineCallbacks.add(onOnline);
    if (onOffline != null) _offlineCallbacks.add(onOffline);

    // Initialize the single subscription if it doesn't exist
    _statusSubscription ??= _connectionStatusController.stream.listen((
      network,
    ) {
      if (network case NetworkStatus.offline) {
        // Create a defensive copy to avoid concurrent modification
        final callbacksCopy = Set<VoidCallback>.from(_offlineCallbacks);
        for (final callback in callbacksCopy) {
          // Check if the callback is still in the original set before calling
          if (_offlineCallbacks.contains(callback)) {
            callback();
          }
        }
      } else {
        // Create a defensive copy to avoid concurrent modification
        final callbacksCopy = Set<VoidCallback>.from(_onlineCallbacks);
        for (final callback in callbacksCopy) {
          // Check if the callback is still in the original set before calling
          if (_onlineCallbacks.contains(callback)) {
            callback();
          }
        }
      }
    });
  }

  @override
  void removeListener({VoidCallback? onOnline, VoidCallback? onOffline}) {
    if (onOnline != null) _onlineCallbacks.remove(onOnline);
    if (onOffline != null) _offlineCallbacks.remove(onOffline);

    // Cancel subscription if no more callbacks
    if (_onlineCallbacks.isEmpty && _offlineCallbacks.isEmpty) {
      _statusSubscription?.cancel();
      _statusSubscription = null;
    }
  }

  // Remove all listeners
  @visibleForTesting
  void clearStatusChangeListeners() {
    _onlineCallbacks.clear();
    _offlineCallbacks.clear();
    _statusSubscription?.cancel();
    _statusSubscription = null;
  }

  @override
  void dispose() {
    // Clean up all status listeners
    clearStatusChangeListeners();

    // Clean up main controller and subscription
    _connectionStatusController.close();
    _subscription.cancel();
  }

  @override
  Stream<NetworkStatus> get connectionStatusStream =>
      _connectionStatusController.stream;
}
