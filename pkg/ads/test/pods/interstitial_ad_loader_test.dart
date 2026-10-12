import 'package:ads/implementations/google_interstitial_ad_loader.dart';
import 'package:ads/pods/interstitial_ad_loader.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('interstitialAdLoaderPod exposes the live Google loader', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(interstitialAdLoaderPod),
      isA<GoogleInterstitialAdLoader>(),
    );
  });
}
