import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isXSS', () {
    test('returns false for null and empty input', () {
      expect(isXSS(null), isFalse);
      expect(isXSS(''), isFalse);
    });

    test('returns false for plain text', () {
      expect(isXSS('Hello, world!'), isFalse);
    });

    test('detects script tags', () {
      expect(isXSS('<script>alert(1)</script>'), isTrue);
    });

    test('detects javascript URLs', () {
      expect(isXSS('javascript:alert(1)'), isTrue);
    });

    test('detects inline event handlers', () {
      expect(isXSS('<img onerror="alert(1)">'), isTrue);
    });

    test('detects generic HTML tags', () {
      expect(isXSS('<div>content</div>'), isTrue);
    });
  });
}
