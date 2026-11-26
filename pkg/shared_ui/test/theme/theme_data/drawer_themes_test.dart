import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_ui/theme/theme_data/drawer_themes.dart';

void main() {
  group('DrawerThemes', () {
    test('light and dark return DrawerThemeData', () {
      expect(DrawerThemes.light(), isA<DrawerThemeData>());
      expect(DrawerThemes.dark(), isA<DrawerThemeData>());
    });
  });
}
