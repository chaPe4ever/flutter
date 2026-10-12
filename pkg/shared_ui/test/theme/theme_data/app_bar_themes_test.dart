import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/app_bar_themes.dart';

void main() {
  group('AppBarThemes', () {
    test('light and dark return AppBarTheme', () {
      expect(AppBarThemes.light(), isA<AppBarTheme>());
      expect(AppBarThemes.dark(), isA<AppBarTheme>());
    });
  });
}
