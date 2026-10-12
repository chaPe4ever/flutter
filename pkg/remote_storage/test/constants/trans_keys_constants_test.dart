import 'package:flutter_test/flutter_test.dart';
import 'package:remote_storage/constants/trans_keys_constants.dart';

void main() {
  test('firebase remote storage exception message key is stable', () {
    expect(
      TransKeys.firebaseRemoteStorageExceptionMessageKey,
      'firebase_remote_storage_exception_message_key',
    );
  });
}
