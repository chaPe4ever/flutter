import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_storage/constants/trans_keys_constants.dart';
import 'package:remote_storage/exceptions/remote_storage_exceptions.dart';
import 'package:remote_storage/extensions/firebase_exception_extension.dart';

void main() {
  test('maps FirebaseException to FirebaseRemoteStorageException', () {
    final stack = StackTrace.current;
    final error = FirebaseException(
      plugin: 'firebase_storage',
      code: 'object-not-found',
      message: 'Missing object',
      stackTrace: stack,
    );

    final mapped = error.toFirestoreRemoteStorageEx();

    expect(mapped, isA<FirebaseRemoteStorageException>());
    expect(
      mapped.messageKey,
      TransKeys.firebaseRemoteStorageExceptionMessageKey,
    );
    expect(mapped.innerCode, 'object-not-found');
    expect(mapped.innerMessage, 'Missing object');
    expect(mapped.innerError, same(error));
    expect(mapped.st, same(stack));
    expect(
      mapped.toString(),
      startsWith(
        'remote_storage : firebase_remote_storage_exception_message_key '
        '(Missing object | [firebase_storage/object-not-found] Missing object',
      ),
    );
  });

  test('honours a custom message key', () {
    final error = FirebaseException(
      plugin: 'firebase_storage',
      code: 'canceled',
      message: 'Canceled',
    );

    final mapped = error.toFirestoreRemoteStorageEx(
      messageKey: 'custom_message_key',
    );

    expect(mapped.messageKey, 'custom_message_key');
  });
}
