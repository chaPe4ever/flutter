import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/dropdown_menu_themes.dart';

import 'theme_data_test_helpers.dart';

void main() {
  group('DropdownMenuThemes', () {
    test('light resolves menu side and floating label styles', () {
      final theme = DropdownMenuThemes.light();
      theme.menuStyle?.side?.resolve(errorWidgetStates);
      theme.menuStyle?.side?.resolve(emptyWidgetStates);
      resolveWidgetStateTextStyle(
        theme.inputDecorationTheme?.floatingLabelStyle,
        errorWidgetStates,
      );
      resolveWidgetStateTextStyle(
        theme.inputDecorationTheme?.floatingLabelStyle,
        focusedWidgetStates,
      );
      resolveWidgetStateTextStyle(
        theme.inputDecorationTheme?.floatingLabelStyle,
        disabledWidgetStates,
      );
      resolveWidgetStateTextStyle(
        theme.inputDecorationTheme?.floatingLabelStyle,
        emptyWidgetStates,
      );
    });

    test('dark resolves floating label styles', () {
      final theme = DropdownMenuThemes.dark();
      resolveWidgetStateTextStyle(
        theme.inputDecorationTheme?.floatingLabelStyle,
        errorWidgetStates,
      );
      resolveWidgetStateTextStyle(
        theme.inputDecorationTheme?.floatingLabelStyle,
        focusedWidgetStates,
      );
      resolveWidgetStateTextStyle(
        theme.inputDecorationTheme?.floatingLabelStyle,
        disabledWidgetStates,
      );
      resolveWidgetStateTextStyle(
        theme.inputDecorationTheme?.floatingLabelStyle,
        emptyWidgetStates,
      );
    });
  });
}
