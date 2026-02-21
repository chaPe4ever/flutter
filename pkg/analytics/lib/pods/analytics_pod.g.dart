// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
///

@ProviderFor(analytics)
final analyticsPod = AnalyticsProvider._();

///

final class AnalyticsProvider
    extends $FunctionalProvider<AnalyticsBase, AnalyticsBase, AnalyticsBase>
    with $Provider<AnalyticsBase> {
  ///
  AnalyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsHash();

  @$internal
  @override
  $ProviderElement<AnalyticsBase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnalyticsBase create(Ref ref) {
    return analytics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsBase>(value),
    );
  }
}

String _$analyticsHash() => r'080a01462709556363c7d9fc5ef3f7c75d1de6a2';
