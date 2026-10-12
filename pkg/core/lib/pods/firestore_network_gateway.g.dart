// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_network_gateway.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firestoreNetworkGateway)
final firestoreNetworkGatewayPod = FirestoreNetworkGatewayProvider._();

final class FirestoreNetworkGatewayProvider
    extends
        $FunctionalProvider<
          FirestoreNetworkGateway,
          FirestoreNetworkGateway,
          FirestoreNetworkGateway
        >
    with $Provider<FirestoreNetworkGateway> {
  FirestoreNetworkGatewayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firestoreNetworkGatewayPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firestoreNetworkGatewayHash();

  @$internal
  @override
  $ProviderElement<FirestoreNetworkGateway> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirestoreNetworkGateway create(Ref ref) {
    return firestoreNetworkGateway(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirestoreNetworkGateway value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirestoreNetworkGateway>(value),
    );
  }
}

String _$firestoreNetworkGatewayHash() =>
    r'c7baae77ce979ef9b2520c835ec171d1262b41d2';
