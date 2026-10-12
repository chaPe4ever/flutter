// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_ads.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mobileAds)
final mobileAdsPod = MobileAdsProvider._();

final class MobileAdsProvider
    extends
        $FunctionalProvider<MobileAdsClient, MobileAdsClient, MobileAdsClient>
    with $Provider<MobileAdsClient> {
  MobileAdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mobileAdsPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mobileAdsHash();

  @$internal
  @override
  $ProviderElement<MobileAdsClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MobileAdsClient create(Ref ref) {
    return mobileAds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MobileAdsClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MobileAdsClient>(value),
    );
  }
}

String _$mobileAdsHash() => r'5b3ca8842e5e3665e7ae2fafba8e72413258a421';
