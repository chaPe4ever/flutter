abstract interface class ReviewPromptClient {
  Future<bool> isAvailable();

  Future<void> requestReview();

  Future<void> openStoreListing({
    String? appStoreId,
    String? microsoftStoreId,
    String? googlePlayId,
  });
}
