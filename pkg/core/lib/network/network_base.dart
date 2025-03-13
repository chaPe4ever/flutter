import 'dart:async';

import 'package:core/network/network_status.dart';
import 'package:flutter/foundation.dart';

/// Network connection interface
abstract interface class NetworkBase {
  /// Checks if the devices is connected to internet
  Future<bool> get isConnected;

  Stream<NetworkStatus> get connectionStatusStream;

  /// Dispose the connection when there is no usage
  void dispose();

  /// Network changes  listeners
  void addListener({VoidCallback? onOnline, VoidCallback? onOffline});
  void removeListener({VoidCallback? onOnline, VoidCallback? onOffline});
}
