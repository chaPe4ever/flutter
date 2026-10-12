import 'package:core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'interstitial_ad_load_config.g.dart';

/// Interstitial ad unit and request configured during ads initialization.
@Riverpod(keepAlive: true)
class InterstitialAdLoadConfig extends _$InterstitialAdLoadConfig {
  @override
  ({String? adUnitId, AdRequest? adRequest}) build() =>
      (adUnitId: null, adRequest: null);

  void configure({
    required String adUnitId,
    required AdRequest adRequest,
  }) {
    state = (adUnitId: adUnitId, adRequest: adRequest);
  }

  void clear() {
    state = (adUnitId: null, adRequest: null);
  }
}
