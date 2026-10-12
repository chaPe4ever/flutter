import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateId', () {
    test('rejects null and empty strings', () {
      for (final input in [null, '']) {
        final result = validateId(input);
        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error.messageKey, 'id_cannot_be_empty'),
          (_) => fail('expected left'),
        );
      }
    });

    test('accepts non-empty strings', () {
      expect(
        validateId('abc-123'),
        right<CoreException, String>('abc-123'),
      );
    });
  });

  group('UniqueId', () {
    test('factory generates a non-empty id', () {
      final id = UniqueId();
      expect(id.isValid(), isTrue);
      expect(id.requireValue, isNotEmpty);
    });

    test('fromUniqueString wraps a trusted id', () {
      const raw = 'trusted-id';
      final id = UniqueId.fromUniqueString(raw);
      expect(id.requireValue, raw);
      expect(id.valueOrNull, raw);
    });

    test('validator returns null for valid input', () {
      final id = UniqueId.fromUniqueString('ok');
      expect(id.validator('still-ok'), isNull);
    });

    test('validator returns a message key translation for invalid input', () {
      final id = UniqueId.fromUniqueString('ok');
      final message = id.validator('');
      expect(message, isNotNull);
      expect(message, isNotEmpty);
    });

    test('equality follows the underlying Either value', () {
      final a = UniqueId.fromUniqueString('same');
      final b = UniqueId.fromUniqueString('same');
      final c = UniqueId.fromUniqueString('other');

      expect(a, equals(b));
      expect(a == c, isFalse);
    });
  });
}
