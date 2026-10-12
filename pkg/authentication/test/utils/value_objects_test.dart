import 'package:authentication/exceptions/auth_exceptions.dart';
import 'package:authentication/utils/value_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/auth_dartz.dart';

void main() {
  group('EmailAddress', () {
    test('wraps valid input in a right value', () {
      final email = EmailAddress('user@example.com');

      expect(email.value, isA<Right<CoreException, String>>());
      expect(email.requireValue, 'user@example.com');
    });

    test('wraps invalid input in a left value', () {
      final email = EmailAddress('bad');

      expect(email.value, validationLeft(const InvalidEmailException()));
    });

    test('validator returns null for valid input', () {
      expect(
        EmailAddress('user@example.com').validator('user@example.com'),
        isNull,
      );
    });

    test('validator returns a message for invalid input', () {
      final message = EmailAddress('bad').validator('bad');

      expect(message, isNotNull);
      expect(message, isNotEmpty);
    });
  });

  group('Password', () {
    test('wraps valid input in a right value', () {
      final password = Password('secret12');

      expect(password.requireValue, 'secret12');
    });

    test('wraps invalid input in a left value', () {
      final password = Password('123');

      expect(password.value, validationLeft(const InvalidPasswordException()));
    });

    test('validator returns null for valid input', () {
      expect(Password('secret12').validator('secret12'), isNull);
    });

    test('validator returns a message for invalid input', () {
      expect(Password('123').validator('123'), isNotNull);
    });
  });
}
