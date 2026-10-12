import 'package:analytics/implementations/firebase_analytics_impl.dart';
import 'package:analytics/pods/analytics_pod.dart';
import 'package:core/core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';

const _firebaseOptions = FirebaseOptions(
  apiKey: 'api-key',
  appId: '1:1:web:abc',
  messagingSenderId: '1',
  projectId: 'project-id',
);

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    try {
      await Firebase.initializeApp(options: _firebaseOptions);
    } on FirebaseException catch (error) {
      if (error.code != 'duplicate-app') {
        rethrow;
      }
    }
  });

  test('analyticsPod exposes FirebaseAnalyticsImpl', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(analyticsPod), isA<FirebaseAnalyticsImpl>());
  });
}
