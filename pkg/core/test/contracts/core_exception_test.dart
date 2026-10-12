import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoreException.toString', () {
    test('keeps the package prefix and message key', () {
      expect(
        UnknownCoreException().toString(),
        'core : unknown_core_exception_message_key',
      );
    });

    test('omits the prefix when it is unset', () {
      expect(
        const _BareException(messageKey: 'plain_key').toString(),
        'plain_key',
      );
    });

    test('appends the inner message and the original error', () {
      expect(
        UnknownCoreException(
          innerMessage: 'disk full',
          innerError: StateError('no space'),
        ).toString(),
        'core : unknown_core_exception_message_key '
        '(disk full | Bad state: no space)',
      );
    });

    test('appends only the original error when the inner message is empty', () {
      expect(
        const _BareException(
          messageKey: 'plain_key',
          innerMessage: '',
          innerError: 'socket closed',
        ).toString(),
        'plain_key (socket closed)',
      );
    });
  });
}

final class _BareException extends CoreException {
  const _BareException({
    required super.messageKey,
    super.innerMessage,
    super.innerError,
  });
}
