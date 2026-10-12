import 'package:authentication/utils/helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('generateNonce', () {
    test('returns a string of the requested length', () {
      expect(generateNonce(16).length, 16);
      expect(generateNonce().length, 32);
    });

    test('uses only allowed charset characters', () {
      const charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final nonce = generateNonce(128);

      for (final codeUnit in nonce.codeUnits) {
        expect(charset.contains(String.fromCharCode(codeUnit)), isTrue);
      }
    });

    test('generates different values on successive calls', () {
      expect(generateNonce(), isNot(generateNonce()));
    });
  });

  group('sha256ofString', () {
    test('returns the known SHA-256 hex digest', () {
      expect(
        sha256ofString('hello'),
        '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824',
      );
    });

    test('returns lowercase hex', () {
      final digest = sha256ofString('nonce');

      expect(digest, matches(RegExp(r'^[0-9a-f]{64}$')));
    });
  });
}
