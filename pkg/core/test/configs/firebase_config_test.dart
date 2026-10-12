import 'package:core/configs/firebase_config.dart';
import 'package:core/core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';

const _options = FirebaseOptions(
  apiKey: 'api-key',
  appId: '1:1:web:abc',
  messagingSenderId: '1',
  projectId: 'project-id',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(setupFirebaseCoreMocks);

  group('FirebaseConfig.init', () {
    test('initialises Firebase with the provided options', () async {
      final config = FirebaseConfig(firebaseOptions: _options);
      expect(config.firebaseOptions.projectId, 'project-id');

      try {
        await config.init();
      } on FirebaseException catch (e) {
        if (e.code == 'duplicate-app') {
          return;
        }
        rethrow;
      }

      expect(Firebase.app().options.projectId, 'project-id');
    });
  });
}
