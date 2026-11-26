import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_ui/theme/theme_data/text_themes.dart';

void main() {
  group('TextThemes', () {
    test('light and dark return TextTheme', () {
      expect(TextThemes.light(), isA<TextTheme>());
      expect(TextThemes.dark(), isA<TextTheme>());
    });
  });
}
