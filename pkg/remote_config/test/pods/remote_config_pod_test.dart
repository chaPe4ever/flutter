import 'package:core/core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_config/implementations/firebase_remote_config_impl.dart';
import 'package:remote_config/pods/firebase_remote_config_pod.dart';
import 'package:remote_config/pods/remote_config_pod.dart';

import '../helpers/firebase_remote_config_test_setup.dart';

void main() {
  late FirebaseRemoteConfig firebaseRemoteConfig;

  setUpAll(() async {
    firebaseRemoteConfig = await setupFirebaseRemoteConfigForTests();
  });

  test('remoteConfigPod builds impl and disposes on container dispose', () {
    final container = ProviderContainer(
      overrides: [
        firebaseRemoteConfigPod.overrideWithValue(firebaseRemoteConfig),
      ],
    );
    addTearDown(container.dispose);

    final remoteConfig = container.read(remoteConfigPod);
    expect(remoteConfig, isA<FirebaseRemoteConfigImpl>());
    expect(remoteConfig.isFetchSucceeded, isTrue);
  });
}
