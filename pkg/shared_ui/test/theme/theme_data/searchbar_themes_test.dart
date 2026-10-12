import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/searchbar_themes.dart';

import 'theme_data_test_helpers.dart';

void main() {
  group('SearchbarThemes', () {
    test('light and dark resolve search bar widget states', () {
      for (final theme in [SearchbarThemes.light(), SearchbarThemes.dark()]) {
        theme.backgroundColor?.resolve(emptyWidgetStates);
        theme.overlayColor?.resolve(emptyWidgetStates);
        theme.surfaceTintColor?.resolve(emptyWidgetStates);
        theme.hintStyle?.resolve(emptyWidgetStates);
        theme.textStyle?.resolve(emptyWidgetStates);
      }
    });
  });
}
