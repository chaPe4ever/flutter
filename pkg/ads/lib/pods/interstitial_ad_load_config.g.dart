// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interstitial_ad_load_config.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Interstitial ad unit and request used after [Ads.init].

@ProviderFor(InterstitialAdLoadConfig)
final interstitialAdLoadConfigPod = InterstitialAdLoadConfigProvider._();

/// Interstitial ad unit and request used after [Ads.init].
final class InterstitialAdLoadConfigProvider
    extends
        $NotifierProvider<
          InterstitialAdLoadConfig,
          ({AdRequest? adRequest, String? adUnitId})
        > {
  /// Interstitial ad unit and request used after [Ads.init].
  InterstitialAdLoadConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interstitialAdLoadConfigPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interstitialAdLoadConfigHash();

  @$internal
  @override
  InterstitialAdLoadConfig create() => InterstitialAdLoadConfig();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({AdRequest? adRequest, String? adUnitId}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<({AdRequest? adRequest, String? adUnitId})>(value),
    );
  }
}

String _$interstitialAdLoadConfigHash() =>
    r'5a4358dfdbf9c6404ad21d860504cad1556dd4c1';

/// Interstitial ad unit and request used after [Ads.init].

abstract class _$InterstitialAdLoadConfig
    extends $Notifier<({AdRequest? adRequest, String? adUnitId})> {
  ({AdRequest? adRequest, String? adUnitId}) build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              ({AdRequest? adRequest, String? adUnitId}),
              ({AdRequest? adRequest, String? adUnitId})
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({AdRequest? adRequest, String? adUnitId}),
                ({AdRequest? adRequest, String? adUnitId})
              >,
              ({AdRequest? adRequest, String? adUnitId}),
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
