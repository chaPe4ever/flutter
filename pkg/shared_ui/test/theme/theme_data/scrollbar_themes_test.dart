import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/scrollbar_themes.dart';

import 'theme_data_test_helpers.dart';

void main() {
  group('ScrollbarThemes', () {
    test('light and dark resolve thumb visibility and thickness', () {
      for (final theme in [ScrollbarThemes.light(), ScrollbarThemes.dark()]) {
        theme.thumbColor?.resolve(emptyWidgetStates);
        theme.thumbVisibility?.resolve(emptyWidgetStates);
        theme.thickness?.resolve(emptyWidgetStates);
      }
    });
  });
}
