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
    extends $FunctionalProvider<MobileAds, MobileAds, MobileAds>
    with $Provider<MobileAds> {
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
  $ProviderElement<MobileAds> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MobileAds create(Ref ref) {
    return mobileAds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MobileAds value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MobileAds>(value),
    );
  }
}

String _$mobileAdsHash() => r'0cc041e53bf308d5384483868fc2a8d2cfc21f02';
