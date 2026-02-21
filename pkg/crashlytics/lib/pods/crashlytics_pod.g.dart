// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crashlytics_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
///

@ProviderFor(crashlytics)
final crashlyticsPod = CrashlyticsProvider._();

///

final class CrashlyticsProvider
    extends
        $FunctionalProvider<CrashlyticsBase, CrashlyticsBase, CrashlyticsBase>
    with $Provider<CrashlyticsBase> {
  ///
  CrashlyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crashlyticsPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crashlyticsHash();

  @$internal
  @override
  $ProviderElement<CrashlyticsBase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CrashlyticsBase create(Ref ref) {
    return crashlytics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrashlyticsBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrashlyticsBase>(value),
    );
  }
}

String _$crashlyticsHash() => r'4ac36cdeb0aba8b7e2868d38f376a36c656cc2ec';
