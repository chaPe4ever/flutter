import 'package:core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'mobile_ads.g.dart';

@Riverpod(keepAlive: true)
MobileAds mobileAds(Ref ref) {
  return MobileAds.instance;
}
