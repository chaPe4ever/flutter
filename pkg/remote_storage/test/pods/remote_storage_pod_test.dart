import 'package:core/core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_storage/implementations/firebase_storage_impl.dart';
import 'package:remote_storage/pods/remote_storage_pod.dart';

import '../helpers/firebase_core_test_setup.dart';
import '../helpers/firebase_storage_test_mocks.dart';

void main() {
  setUpAll(setupRemoteStorageFirebaseCore);

  group('remoteStoragePod', () {
    test('builds FirebaseRemoteStorageImpl from firebaseStoragePod', () {
      final storage = MockFirebaseStorage();
      final container = ProviderContainer(
        overrides: [firebaseStoragePod.overrideWithValue(storage)],
      );
      addTearDown(container.dispose);

      final remote = container.read(remoteStoragePod);

      expect(remote, isA<FirebaseRemoteStorageImpl>());
    });
  });

  group('firebaseStoragePod', () {
    test('returns FirebaseStorage.instance after Firebase init', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(firebaseStoragePod), FirebaseStorage.instance);
    });
  });
}
