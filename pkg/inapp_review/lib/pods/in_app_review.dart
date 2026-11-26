import 'package:core/core.dart';
import 'package:inapp_review/contracts/review_prompt_client.dart';
import 'package:inapp_review/implementations/rate_my_app_review_prompt_client.dart';

final inAppReviewPod = Provider<ReviewPromptClient>((ref) {
  return const RateMyAppReviewPromptClient();
});
