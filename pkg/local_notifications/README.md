This package makes use of the firebase crashlytics API wrapped around Riverpod

## Features

- showNotification
- cancelNotification
- cancelAllNotifications

## Getting started

Add the following to your AndroidManifest.xml and info.plist.
More details [here](https://pub.dev/packages/flutter_local_notifications#cancellingdeleting-all-notifications)

#### Android (android/app/src/main/AndroidManifest.xml)

```
<manifest>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <application>
        ...

        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ActionBroadcastReceiver" />
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>
    </application>
</manifest>
```

#### iOS (ios/Runner/Info.plist)

```
  <key>UIBackgroundModes</key>
  <array>
  <string>fetch</string>
  <string>remote-notification</string>
  </array>
```

Initialise the pkg by calling this before starting your app:

```dart
main(){
    ...

    Either make use of uncontrolled ProvideScope or add a startupPage/Provider where you can initialise the pkg:

    // This will initialise the pkg
    ref.listen(localNotificationsPod, (_,_){});
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
            .read(localNotificationsPod.notifier)
            .showNotification(
              title: 'Title',
              body: 'Body',
            )
}
  
```

## Additional information

The current API is:

```dart
  Future<void> showNotification({
    required String title,
    required String body,
    required int id,
    String? payload,
    List<NotificationActionBase>? actions,
    String? channelId,
    String? sound,
    String gorupKey = 'com.gameroom/local_notifications',
    int? badgeNumber,
  });

  Future<void> cancelNotification({required int id});

  Future<void> cancelAllNotifications();
```
