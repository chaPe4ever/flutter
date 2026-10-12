import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/checkbox_themes.dart';

import 'theme_data_test_helpers.dart';

void main() {
  group('CheckboxThemes', () {
    test('light and dark resolve fill, check, and overlay colors', () {
      for (final theme in [CheckboxThemes.light(), CheckboxThemes.dark()]) {
        theme.fillColor?.resolve(selectedWidgetStates);
        theme.fillColor?.resolve(emptyWidgetStates);
        theme.checkColor?.resolve(emptyWidgetStates);
        theme.overlayColor?.resolve(emptyWidgetStates);
      }
    });
  });
}
