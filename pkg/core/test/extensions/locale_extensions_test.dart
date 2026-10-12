import 'package:core/extensions/locale_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocaleX', () {
    test('toStringWithSeparator replaces underscore', () {
      const locale = Locale('en', 'US');
      expect(locale.toStringWithSeparator(), 'en_US');
      expect(locale.toStringWithSeparator(separator: '-'), 'en-US');
    });
  });
}
