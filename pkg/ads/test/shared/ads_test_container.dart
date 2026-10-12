import 'package:ads/contracts/consent_client.dart';
import 'package:ads/contracts/interstitial_ad_loader.dart';
import 'package:ads/implementations/google_consent_client.dart';
import 'package:ads/implementations/google_interstitial_ad_loader.dart';
import 'package:ads/pods/ads.dart';
import 'package:ads/pods/consent.dart';
import 'package:ads/pods/interstitial_ad_loader.dart';
import 'package:ads/pods/mobile_ads.dart';
import 'package:core/core.dart';

import 'fake_mobile_ads_client.dart';

ProviderContainer createAdsTestContainer({
  FakeMobileAdsClient? mobileAds,
  ConsentClient? consentClient,
  InterstitialAdLoader? interstitialAdLoader,
}) {
  final client = mobileAds ?? FakeMobileAdsClient();
  return ProviderContainer(
    overrides: [
      mobileAdsPod.overrideWithValue(client),
      consentClientPod.overrideWithValue(
        consentClient ?? GoogleConsentClient(),
      ),
      interstitialAdLoaderPod.overrideWithValue(
        interstitialAdLoader ?? GoogleInterstitialAdLoader(),
      ),
    ],
  );
}

Future<Ads> readAdsNotifier(ProviderContainer container) async {
  await container.read(adsPod.future);
  return container.read(adsPod.notifier);
}
