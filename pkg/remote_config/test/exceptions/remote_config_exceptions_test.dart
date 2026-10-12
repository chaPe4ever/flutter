import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_config/constants/remote_config_constants.dart';
import 'package:remote_config/constants/trans_keys_constants.dart';
import 'package:remote_config/exceptions/remote_config_exceptions.dart';

void main() {
  test('TransKeys exposes the firebase exception message key', () {
    expect(
      TransKeys.remoteConfigFirebaseExceptionMessageKey,
      'remote_config_firebase_exception_message_key',
    );
  });

  group('RemoteConfigFirebaseException', () {
    test('uses the remote_config package prefix by default', () {
      const exception = RemoteConfigFirebaseException();
      expect(exception.prefix, kRemoteConfigPkgName);
      expect(
        exception.messageKey,
        TransKeys.remoteConfigFirebaseExceptionMessageKey,
      );
    });

    test('formats like other core exceptions', () {
      expect(
        RemoteConfigFirebaseException(
          innerMessage: 'fetch failed',
          innerError: StateError('bad'),
        ).toString(),
        'remote_config : remote_config_firebase_exception_message_key '
        '(fetch failed | Bad state: bad)',
      );
    });

    test('is a RemoteConfigEx', () {
      const exception = RemoteConfigFirebaseException();
      expect(exception, isA<RemoteConfigEx>());
      expect(exception, isA<CoreException>());
    });
  });
}
