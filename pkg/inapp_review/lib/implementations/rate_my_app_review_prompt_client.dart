import 'package:flutter/foundation.dart';
import 'package:inapp_review/contracts/review_prompt_client.dart';
import 'package:rate_my_app/rate_my_app.dart';

final class RateMyAppReviewPromptClient implements ReviewPromptClient {
  const new({
    this.googlePlayIdentifier,
    this.appStoreIdentifier,
  });

  final String? googlePlayIdentifier;
  final String? appStoreIdentifier;

  @override
  Future<bool> isAvailable() async {
    final rateMyApp = _createRateMyApp();
    return (await rateMyApp.isNativeReviewDialogSupported) ?? false;
  }

  @override
  Future<void> requestReview() {
    return _createRateMyApp().launchNativeReviewDialog();
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
    await _createRateMyApp(
      appStoreId: appStoreId,
      googlePlayId: googlePlayId,
    ).launchStore();
  }

  RateMyApp _createRateMyApp({String? appStoreId, String? googlePlayId}) {
    return RateMyApp.customConditions(
      conditions: const [],
      appStoreIdentifier: appStoreId ?? appStoreIdentifier,
      googlePlayIdentifier: googlePlayId ?? googlePlayIdentifier,
    );
  }
}
