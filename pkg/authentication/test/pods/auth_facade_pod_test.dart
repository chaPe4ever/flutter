import 'package:authentication/implementations/fake_auth_facade.dart';
import 'package:authentication/implementations/firebase_auth_facade.dart';
import 'package:authentication/pods/auth_facade_pod.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/auth_mocks.dart';
import '../helpers/fake_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(setupFirebaseCoreMocks);

  tearDown(AppModeHelper().reset);

  group('authFacadePod', () {
    test('returns FakeAuthFacade in fake app mode', () {
      AppModeHelper().setMode(AppModeEnum.fake);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(authFacadePod), isA<FakeAuthFacade>());
    });

    test('returns FirebaseAuthFacade in real app mode with overrides', () {
      AppModeHelper().setMode(AppModeEnum.real);
      final firebaseAuth = MockFirebaseAuth();
      final logger = FakeLogger();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthPod.overrideWithValue(firebaseAuth),
          loggerPod.overrideWithValue(logger),
        ],
      );
      addTearDown(container.dispose);

      final facade = container.read(authFacadePod);
      expect(facade, isA<FirebaseAuthFacade>());
    });

    test('firebaseAuthPod exposes the override value', () {
      final firebaseAuth = MockFirebaseAuth();

      final container = ProviderContainer(
        overrides: [firebaseAuthPod.overrideWithValue(firebaseAuth)],
      );
      addTearDown(container.dispose);

      expect(container.read(firebaseAuthPod), same(firebaseAuth));
    });

    test(
      'firebaseAuthPod returns FirebaseAuth.instance when initialized',
      () async {
        const options = FirebaseOptions(
          apiKey: 'api-key',
          appId: '1:1:web:abc',
          messagingSenderId: '1',
          projectId: 'project-id',
        );

        try {
          await Firebase.initializeApp(options: options);
        } on FirebaseException catch (e) {
          if (e.code != 'duplicate-app') {
            rethrow;
          }
        }

        final container = ProviderContainer();
        addTearDown(container.dispose);

        expect(container.read(firebaseAuthPod), FirebaseAuth.instance);
      },
    );

    test('disposes the facade when the container is disposed', () {
      AppModeHelper().setMode(AppModeEnum.fake);

      final container = ProviderContainer();
      final facade = container.read(authFacadePod) as FakeAuthFacade;

      expect(container.dispose, returnsNormally);
      facade.dispose();
    });
  });
}
