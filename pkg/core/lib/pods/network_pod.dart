import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/network/network_base.dart';
import 'package:core/network/network_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_pod.g.dart';

/// Network connection pod
@Riverpod(keepAlive: true)
NetworkBase network(Ref ref) {
  final networkBase = NetworkImpl(connectivity: Connectivity());

  // As keepAlive is true, it should never hit onDispose but just for safety..
  ref.onDispose(networkBase.dispose);

  return networkBase;
}
