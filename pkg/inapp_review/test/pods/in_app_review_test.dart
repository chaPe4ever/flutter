import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inapp_review/implementations/rate_my_app_review_prompt_client.dart';
import 'package:inapp_review/pods/in_app_review.dart';

void main() {
  test('inAppReviewPod exposes RateMyAppReviewPromptClient', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(inAppReviewPod),
      isA<RateMyAppReviewPromptClient>(),
    );
  });
}
