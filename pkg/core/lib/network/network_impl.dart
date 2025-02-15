import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/network/network_base.dart';
import 'package:core/network/network_status.dart';
import 'package:flutter/foundation.dart';

/// Network connection implementation
final class NetworkImpl implements NetworkBase {
  /// Constructor
  NetworkImpl({required Connectivity connectivity})
      : _connectivity = connectivity,
        _connectionStatusController =
            StreamController<NetworkStatus>.broadcast() {
    _subscription =
        _connectivity.onConnectivityChanged.distinct().listen((results) {
      _connectionStatusController.add(getStatusFromResult(results.last));
    });
  }

  // Fields
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  final StreamController<NetworkStatus> _connectionStatusController;
  final Connectivity _connectivity;

  // Methods
  @override
  Future<bool> get isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();

    return !connectivityResult.contains(ConnectivityResult.none);
  }

  @override
  StreamController<NetworkStatus> get connectionStatusController =>
      _connectionStatusController;

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
      ConnectivityResult.other =>
        NetworkStatus.other
    };
  }

  @override
  void dispose() {
    _connectionStatusController.close();
    _subscription.cancel();
  }

  @override
  void statusChangeListener({
    VoidCallback? onOnline,
    VoidCallback? onOffline,
  }) {
    assert(
      onOnline != null || onOffline != null,
      'At least one of onOnline or onOffline must be provided',
    );
    // Listen for connectivity changes and show snackBar
    _connectionStatusController.stream.listen((network) {
      if (network case NetworkStatus.offline) {
        onOffline?.call();
      } else {
        onOnline?.call();
      }
    });
  }
}
