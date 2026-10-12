import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/switch_themes.dart';

import 'theme_data_test_helpers.dart';

void main() {
  group('SwitchThemes', () {
    test('light and dark resolve track, thumb, and outline colors', () {
      for (final theme in [SwitchThemes.light(), SwitchThemes.dark()]) {
        theme.trackColor?.resolve(selectedWidgetStates);
        theme.trackColor?.resolve(emptyWidgetStates);
        theme.thumbColor?.resolve(selectedWidgetStates);
        theme.thumbColor?.resolve(emptyWidgetStates);
        theme.trackOutlineColor?.resolve(emptyWidgetStates);
      }
    });
  });
}
