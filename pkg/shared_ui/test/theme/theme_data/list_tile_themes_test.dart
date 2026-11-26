import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_ui/theme/theme_data/list_tile_themes.dart';

void main() {
  group('ListTileThemes', () {
    test('light and dark return ListTileThemeData', () {
      expect(ListTileThemes.light(), isA<ListTileThemeData>());
      expect(ListTileThemes.dark(), isA<ListTileThemeData>());
    });
  });
}
