import 'package:authentication/exceptions/auth_exceptions.dart';
import 'package:authentication/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/auth_dartz.dart';

void main() {
  group('validateEmailAddress', () {
    test('accepts a valid email', () {
      final result = validateEmailAddress('user@example.com');

      expect(result, isA<Right<CoreException, String>>());
      expect(result.getOrElse(() => ''), 'user@example.com');
    });

    test('rejects null input', () {
      final result = validateEmailAddress(null);

      expect(result, validationLeft(const InvalidEmailException()));
    });

    test('rejects invalid email format', () {
      final result = validateEmailAddress('not-an-email');

      expect(result, validationLeft(const InvalidEmailException()));
    });

    test('rejects XSS payloads', () {
      final result = validateEmailAddress('<script>alert(1)</script>@x.com');

      expect(result, validationLeft(const InvalidEmailException()));
    });
  });

  group('validatePassword', () {
    test('accepts password with at least six characters', () {
      final result = validatePassword('secret');

      expect(result, isA<Right<CoreException, String>>());
      expect(result.getOrElse(() => ''), 'secret');
    });

    test('rejects short passwords', () {
      final result = validatePassword('12345');

      expect(result, validationLeft(const InvalidPasswordException()));
    });

    test('rejects null input', () {
      final result = validatePassword(null);

      expect(result, validationLeft(const InvalidPasswordException()));
    });

    test('rejects XSS payloads', () {
      final result = validatePassword('<img onerror=x>');

      expect(result, validationLeft(const InvalidPasswordException()));
    });
  });
}
