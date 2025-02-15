import 'dart:async';

import 'package:core/network/network_status.dart';
import 'package:flutter/foundation.dart';

/// Network connection interface
abstract interface class NetworkBase {
  /// Checks if the devices is connected to internet
  Future<bool> get isConnected;

  /// Stream controller to listen to connection status changes
  StreamController<NetworkStatus> get connectionStatusController;

  /// Dispose the connection when there is no usage
  void dispose();

  /// Network changes listener
  void statusChangeListener({VoidCallback? onOnline, VoidCallback? onOffline});
}
