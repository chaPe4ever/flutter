// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
///

@ProviderFor(remoteConfig)
final remoteConfigPod = RemoteConfigProvider._();

///

final class RemoteConfigProvider
    extends
        $FunctionalProvider<
          RemoteConfigBase,
          RemoteConfigBase,
          RemoteConfigBase
        >
    with $Provider<RemoteConfigBase> {
  ///
  RemoteConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteConfigPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteConfigHash();

  @$internal
  @override
  $ProviderElement<RemoteConfigBase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RemoteConfigBase create(Ref ref) {
    return remoteConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteConfigBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteConfigBase>(value),
    );
  }
}

String _$remoteConfigHash() => r'9cd2108368f98a1785e6a75d1be86847164a7231';
