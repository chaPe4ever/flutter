import 'package:flutter_test/flutter_test.dart';
import 'package:remote_storage/contracts/remote_storage_base.dart';
import 'package:remote_storage/implementations/fake_remote_storage_impl.dart';
import 'package:remote_storage/implementations/firebase_storage_impl.dart';

import '../helpers/firebase_storage_test_mocks.dart';

void main() {
  test('FakeRemoteStorageImpl satisfies RemoteStorageBase', () {
    const impl = FakeRemoteStorageImpl();
    expect(impl, isA<RemoteStorageBase>());
  });

  test('FirebaseRemoteStorageImpl satisfies RemoteStorageBase', () {
    final impl = FirebaseRemoteStorageImpl(
      firebaseStorage: MockFirebaseStorage(),
    );
    expect(impl, isA<RemoteStorageBase>());
  });
}
