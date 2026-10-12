import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/navigation_bar_themes.dart';

import 'theme_data_test_helpers.dart';

void main() {
  group('NavigationBarThemes', () {
    test('light and dark resolve icon and label styles', () {
      for (final theme in [
        NavigationBarThemes.light,
        NavigationBarThemes.dark,
      ]) {
        theme.iconTheme?.resolve(selectedWidgetStates);
        theme.iconTheme?.resolve(emptyWidgetStates);
        theme.labelTextStyle?.resolve(selectedWidgetStates);
        theme.labelTextStyle?.resolve(emptyWidgetStates);
      }
    });
  });
}
