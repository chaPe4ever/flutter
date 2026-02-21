// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Network connection pod

@ProviderFor(network)
final networkPod = NetworkProvider._();

/// Network connection pod

final class NetworkProvider
    extends $FunctionalProvider<NetworkBase, NetworkBase, NetworkBase>
    with $Provider<NetworkBase> {
  /// Network connection pod
  NetworkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkHash();

  @$internal
  @override
  $ProviderElement<NetworkBase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NetworkBase create(Ref ref) {
    return network(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkBase>(value),
    );
  }
}

String _$networkHash() => r'f4f41546ff017fd7827f60527de7ddaaf7dfdf75';
