This package makes use of the firebase crashlytics API wrapped around Riverpod

## Features

- init
- showInterstitialAd

## Getting started

Initialise the pkg by calling this before starting your app:

```dart
main(){
    ...

    Either make use of uncontrolled ProvideScope or add a startupPage/Provider where you can initialise the pkg:

    @Riverpod(keepAlive: true)
    class AppStartup extends _$AppStartup {
    @override
    FutureOr<void> build() async {
      ref.onDispose(() {
        ref.invalidate(adsPod);
      }
       await ref
                .read(adsPod.notifier)
                .init(interstitialAdUnitId:
                // Get you own AdUntiId from Google AdMob
                 AppConstants.interstitialAdUnitId),
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
     await ref
              .read(adsServicePod.notifier)
              .showInterstitialAd();
}
  
```

## Additional information

The current API is:

```dart
  Future<void> init({
    required String interstitialAdUnitId,
    AdRequest adRequest = const AdRequest(),
  });

  Future<void> showInterstitialAd({
    VoidCallback? onAdShowedFullScreenContent,
    VoidCallback? onAdDismissedFullScreenContent,
    VoidCallback? onAdFailedToShowFullScreenContent,
  });
```
