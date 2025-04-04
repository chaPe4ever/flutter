This package makes use of the InAppReview pkg wrapped around Riverpod

## Features

- init
- resetShowFrequency
- show
- canShowReview
- forceShow
- openStoreReview
- markReviewCompleted
- getPromptCount

## Getting started


```dart
main(){
    ...

    Either make use of uncontrolled ProvideScope or add a startupPage/Provider where you can initialise the pkg:

    @Riverpod(keepAlive: true)
    class AppStartup extends _$AppStartup {
    @override
    FutureOr<void> build() async {
      ref.onDispose(() {
        ref.invalidate(inAppReviewServicePod);
      }
       await ref.read(inAppReviewServicePod.notifier).init(),
   }
}
```

## Usage

```dart
...
@override
Widget build(BuildContext context, WidgetRef ref) {
  ...
  // Somewhere in an action
    final reviewService = await ref.read(inAppReviewServicePod.future);
    await reviewService.show();
}
  
```

## Additional information

The current API is:

```dart
   Future<void> init({
    Duration frequency = const Duration(days: 30),
    int maxPrompts = 1000,
  });

  Future<void> resetShowFrequency();

  Future<void> show();

  Future<bool> canShowReview();

  Future<void> forceShow();

  Future<void> openStoreReview({String? appStoreId, String? microsoftStoreId});

  Future<void> markReviewCompleted();

  Future<int> getPromptCount();
```


## Translation keys

- in_app_review_not_supported_device_key
- not_initialised_in_app_review_exception_key