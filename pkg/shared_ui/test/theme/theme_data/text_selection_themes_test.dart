import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_ui/theme/theme_data/text_selection_themes.dart';

void main() {
  group('TextSelectionThemes', () {
    test('light and dark return TextSelectionThemeData', () {
      expect(TextSelectionThemes.light(), isA<TextSelectionThemeData>());
      expect(TextSelectionThemes.dark(), isA<TextSelectionThemeData>());
    });
  });
}
