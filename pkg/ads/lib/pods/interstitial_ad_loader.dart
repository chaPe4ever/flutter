import 'package:ads/contracts/interstitial_ad_loader.dart';
import 'package:ads/implementations/google_interstitial_ad_loader.dart';
import 'package:core/core.dart';

part 'interstitial_ad_loader.g.dart';

@Riverpod(keepAlive: true)
InterstitialAdLoader interstitialAdLoader(Ref ref) =>
    GoogleInterstitialAdLoader();
