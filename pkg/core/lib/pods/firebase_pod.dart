import 'package:cloud_functions/cloud_functions.dart';
import 'package:core/core.dart';

part 'firebase_pod.g.dart';

/// Keep the pod singleton
@Riverpod(keepAlive: true)
FirebaseFirestore firestore(Ref ref) {
  FirebaseFirestore.instance.settings = const Settings(
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    persistenceEnabled: true,
    sslEnabled: true,
    webExperimentalForceLongPolling: true,
    webExperimentalLongPollingOptions: WebExperimentalLongPollingOptions(
      timeoutDuration: Duration(seconds: 30),
    ),
  );

  final subscription = ref
      .watch(networkPod)
      .connectionStatusController
      .stream
      .listen((event) async {
    if (event case NetworkStatus.offline) {
      await FirebaseFirestore.instance.disableNetwork();
    } else {
      await FirebaseFirestore.instance.enableNetwork();
    }
  });

  ref.onDispose(subscription.cancel);

  return FirebaseFirestore.instance;
}

/// Keep the pod singleton
@Riverpod(keepAlive: true)
FirebaseFunctions functions(Ref ref, {String region = 'europe-west3'}) =>
    FirebaseFunctions.instanceFor(region: region);

/// Keep the pod singleton
@Riverpod(keepAlive: true)
FirebaseDatabase firebaseDb(Ref ref) => FirebaseDatabase.instance;
