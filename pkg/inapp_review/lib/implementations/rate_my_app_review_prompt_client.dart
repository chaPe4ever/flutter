import 'package:flutter/foundation.dart';
import 'package:inapp_review/contracts/review_prompt_client.dart';
import 'package:rate_my_app/rate_my_app.dart';

typedef RateMyAppFactory = RateMyApp Function({
  String? appStoreId,
  String? googlePlayId,
});

final class RateMyAppReviewPromptClient implements ReviewPromptClient {
  const new({
    this.googlePlayIdentifier,
    this.appStoreIdentifier,
    RateMyAppFactory? createRateMyApp,
  }) : createRateMyApp = createRateMyApp ?? _defaultCreateRateMyApp;

  final String? googlePlayIdentifier;
  final String? appStoreIdentifier;
  final RateMyAppFactory createRateMyApp;

  static RateMyApp _defaultCreateRateMyApp({
    String? appStoreId,
    String? googlePlayId,
  }) {
    return RateMyApp.customConditions(
      conditions: const [],
      appStoreIdentifier: appStoreId,
      googlePlayIdentifier: googlePlayId,
    );
  }

  @override
  Future<bool> isAvailable() async {
    final rateMyApp = _rateMyApp();
    return (await rateMyApp.isNativeReviewDialogSupported) ?? false;
  }

  @override
  Future<void> requestReview() {
    return _rateMyApp().launchNativeReviewDialog();
  }

  @override
  Future<void> openStoreListing({
    String? appStoreId,
    String? microsoftStoreId,
    String? googlePlayId,
  }) async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return;
    }
    await _rateMyApp(
      appStoreId: appStoreId,
      googlePlayId: googlePlayId,
    ).launchStore();
  }

  RateMyApp _rateMyApp({String? appStoreId, String? googlePlayId}) {
    return createRateMyApp(
      appStoreId: appStoreId ?? appStoreIdentifier,
      googlePlayId: googlePlayId ?? googlePlayIdentifier,
    );
  }
}
