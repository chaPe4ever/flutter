This package makes use of the firebase crashlytics API wrapped around Riverpod

## Features

- init
- showInterstitialAd

## Getting started

Add the following to your AndroidManifest.xml and info.plist.
More details [here](https://docs.flutter.dev/cookbook/plugins/google-mobile-ads)

#### Android (android/app/src/main/AndroidManifest.xml)

```
<manifest>
    <application>
        ...

        <!-- Sample AdMob app ID: ca-app-pub-3940256099942544~3347511713 -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```

#### iOS (ios/Runner/Info.plist)

```
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-################~##########</string>
```

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


## Translation keys

- ads_not_initialised_key
- interstitial_ad_load_failed_key
- interstitial_ad_show_failed_key