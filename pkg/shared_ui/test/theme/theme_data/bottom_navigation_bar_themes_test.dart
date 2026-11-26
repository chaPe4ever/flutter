import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_ui/theme/theme_data/bottom_navigation_bar_themes.dart';

void main() {
  group('BottomNavigationBarThemes', () {
    test('light and dark return BottomNavigationBarThemeData', () {
      expect(
        BottomNavigationBarThemes.light(),
        isA<BottomNavigationBarThemeData>(),
      );
      expect(
        BottomNavigationBarThemes.dark(),
        isA<BottomNavigationBarThemeData>(),
      );
    });
  });
}
