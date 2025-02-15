This package makes use of the firebase crashlytics API wrapped around Riverpod

## Features

- init
- setCrashlytics
- testCrash
- log
- setUserId

## Getting started

Assuming you have registered your project and you have already the `firebase_options` in place, 
then initialise the firebase:

```dart
main(){
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    ...

    Either make use of uncontrolled ProvideScope or add a startupPage/Provider where you can initialise the pkg:

    @Riverpod(keepAlive: true)
    class AppStartup extends _$AppStartup {
    @override
    FutureOr<void> build() async {
      ref.onDispose(() {
        ref.invalidate(crashlyticsPod);
      }
      await ref.read(crashlyticsPod).init();
   }
}
```

## Usage

```dart
...
@override
Widget build(BuildContext context, WidgetRef ref) {
    ref.read(crashlyticsPod).log(message: 'your_msg');
}
  
```

## Additional information

The current API is:

```dart
  /// Might throw [CoreException]
  Future<void> setCrashlytics({required bool enabled});

  ///
  void testCrash();

  /// Might throw [CoreException]
  Future<void> log({required String message});

  /// Might throw [CoreException]
  Future<void> setUserId({required String userId});

  /// Might throw [CoreException]
  Future<void> init();
```
