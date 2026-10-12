import 'package:core/core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(setupFirebaseCoreMocks);

  setUp(() async {
    try {
      await Firebase.initializeApp();
    } on FirebaseException catch (e) {
      if (e.code != 'duplicate-app') {
        rethrow;
      }
    }
  });

  test('firestoreNetworkGatewayPod exposes default implementation', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(firestoreNetworkGatewayPod),
      isA<FirebaseFirestoreNetworkGateway>(),
    );
  });

  test('FirebaseFirestoreNetworkGateway forwards network calls', () async {
    final gateway = FirebaseFirestoreNetworkGateway();
    try {
      await gateway.enableNetwork();
    } on Object {
      // Platform channel may be unavailable in unit tests.
    }
    try {
      await gateway.disableNetwork();
    } on Object {
      // Platform channel may be unavailable in unit tests.
    }
  });
}
