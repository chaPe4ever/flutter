This package makes use of the firebase remote_config API wrapped around Riverpod

## Features

- init
- fetchAndActivate
- dispose
- versionUpdateListener

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
        ref.invalidate(remoteConfigPod);
      }
      await ref.read(remoteConfigPod).init();
   }
}
```

## Usage

```dart
...
@override
Widget build(BuildContext context, WidgetRef ref) {
    ref.read(remoteConfig).fetchAndActivate();
}
  
```

## Additional information

The current API is:

```dart
  /// Initialise the pkg
  /// Might throw [CoreException]
  Future<void> init({
    required NetworkBase network,
    Duration fetchTimeout = const Duration(minutes: 1),
    Duration minimumFetchInterval =
        kDebugMode ? Duration.zero : const Duration(hours: 1),
  });

  /// Stream controller to listen to remote config key changes
  StreamController<Set<String>> get remoteConfigUpdatesController;

  /// It force fetches and activates any updates from remote config
  ///
  /// Might throw [CoreException]
  Future<void> fetchAndActivate();

  /// Dispose the remote config when there is no usage
  void dispose();


  /// Listens for remote app version updates and fetch and activate them
  ///
  /// Might throw [CoreException]
  void versionUpdateListener({required VoidCallback onVersionUpdate});
```


## Translation keys

- remote_config_firebase_exception_message_key