// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interstitial_ad_loader.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(interstitialAdLoader)
final interstitialAdLoaderPod = InterstitialAdLoaderProvider._();

final class InterstitialAdLoaderProvider
    extends
        $FunctionalProvider<
          InterstitialAdLoader,
          InterstitialAdLoader,
          InterstitialAdLoader
        >
    with $Provider<InterstitialAdLoader> {
  InterstitialAdLoaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interstitialAdLoaderPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interstitialAdLoaderHash();

  @$internal
  @override
  $ProviderElement<InterstitialAdLoader> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InterstitialAdLoader create(Ref ref) {
    return interstitialAdLoader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterstitialAdLoader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterstitialAdLoader>(value),
    );
  }
}

String _$interstitialAdLoaderHash() =>
    r'71edf6e0f816727088f2d7a3e079ce8acf9b537c';
