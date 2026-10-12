import 'package:ads/contracts/mobile_ads_client.dart';
import 'package:ads/implementations/google_mobile_ads_client.dart';
import 'package:core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'mobile_ads.g.dart';

@Riverpod(keepAlive: true)
MobileAdsClient mobileAds(Ref ref) {
  return GoogleMobileAdsClient(MobileAds.instance);
}
