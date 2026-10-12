import 'package:flutter_test/flutter_test.dart';
import 'package:remote_storage/constants/remote_storage_constants.dart';
import 'package:remote_storage/constants/trans_keys_constants.dart';
import 'package:remote_storage/exceptions/remote_storage_exceptions.dart';

void main() {
  group('FirebaseRemoteStorageException', () {
    test('uses the remote_storage package prefix by default', () {
      final exception = FirebaseRemoteStorageException(
        messageKey: TransKeys.firebaseRemoteStorageExceptionMessageKey,
      );

      expect(exception.prefix, kRemoteStoragePkgName);
      expect(
        exception.toString(),
        'remote_storage : firebase_remote_storage_exception_message_key',
      );
    });

    test('includes inner details in toString', () {
      final exception = FirebaseRemoteStorageException(
        messageKey: TransKeys.firebaseRemoteStorageExceptionMessageKey,
        innerMessage: 'network down',
        innerError: StateError('offline'),
      );

      expect(
        exception.toString(),
        'remote_storage : firebase_remote_storage_exception_message_key '
        '(network down | Bad state: offline)',
      );
    });
  });
}
