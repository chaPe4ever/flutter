import 'package:core/core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_config/pods/firebase_remote_config_pod.dart';

import '../helpers/firebase_remote_config_integration_test_setup.dart';

void main() {
  setUpAll(setupFirebaseRemoteConfigPodForTests);
  tearDownAll(tearDownFirebaseRemoteConfigPodForTests);

  test('firebaseRemoteConfigPod exposes the Firebase singleton', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(firebaseRemoteConfigPod),
      same(FirebaseRemoteConfig.instance),
    );
  });
}
