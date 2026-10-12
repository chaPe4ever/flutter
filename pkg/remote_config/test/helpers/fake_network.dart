import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

final class FakeNetwork implements NetworkBase {
  FakeNetwork({this.connected = true});

  bool connected;

  @override
  Future<bool> get isConnected async => connected;

  @override
  Stream<NetworkStatus> get connectionStatusStream => const Stream.empty();

  @override
  void dispose() {}

  @override
  void addListener({VoidCallback? onOnline, VoidCallback? onOffline}) {}

  @override
  void removeListener({VoidCallback? onOnline, VoidCallback? onOffline}) {}
}
