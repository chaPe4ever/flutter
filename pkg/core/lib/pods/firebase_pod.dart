import 'package:core/core.dart';

part 'firebase_pod.g.dart';

/// Keep the pod singleton
@Riverpod(keepAlive: true)
FirebaseFirestore firestore(Ref ref) {
  final useEmulator =
      bool.tryParse(const String.fromEnvironment('USE_FIREBASE_EMULATORS')) ??
      false;

  if (useEmulator) {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
      sslEnabled: false,
    );
  } else {
    FirebaseFirestore.instance.settings = const Settings(
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      persistenceEnabled: true,
      sslEnabled: true,
      webExperimentalForceLongPolling: true,
      webExperimentalLongPollingOptions: WebExperimentalLongPollingOptions(
        timeoutDuration: Duration(seconds: 30),
      ),
    );

    void onOnline() {
      FirebaseFirestore.instance.enableNetwork();
    }

    void onOffline() {
      FirebaseFirestore.instance.disableNetwork();
    }

    ref.read(networkPod).addListener(onOnline: onOnline, onOffline: onOffline);

    ref.onDispose(
      () => ref
          .read(networkPod)
          .removeListener(onOnline: onOnline, onOffline: onOffline),
    );
  }

  return FirebaseFirestore.instance;
}

/// Keep the pod singleton
@Riverpod(keepAlive: true)
FirebaseFunctions functions(Ref ref, {String region = 'europe-west3'}) {
  final app = FirebaseFunctions.instance.app;

  return FirebaseFunctions.instanceFor(app: app, region: region);
}

/// Keep the pod singleton
@Riverpod(keepAlive: true)
FirebaseDatabase firebaseDb(Ref ref) => FirebaseDatabase.instance;
