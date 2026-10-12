import 'package:core/core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_firebase_remote_config_platform.dart';

FakeFirebaseRemoteConfigPlatform? _integrationPlatform;

Future<void> setupFirebaseRemoteConfigPodForTests() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  if (_integrationPlatform != null) {
    return;
  }
  setupFirebaseCoreMocks();
  final platform = FakeFirebaseRemoteConfigPlatform();
  _integrationPlatform = platform;
  FirebaseRemoteConfigPlatform.instance = platform;
  await Firebase.initializeApp();
}

Future<void> tearDownFirebaseRemoteConfigPodForTests() async {
  await _integrationPlatform?.dispose();
  _integrationPlatform = null;
}
