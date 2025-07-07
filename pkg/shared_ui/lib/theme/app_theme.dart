import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_effect_styles.dart';
import 'package:shared_ui/theme/app_text_theme.dart';
import 'package:shared_ui/theme/pallete/app_semantic_colors.dart';
import 'package:shared_ui/theme/theme_data/app_bar_themes.dart';
import 'package:shared_ui/theme/theme_data/bottom_navigation_bar_themes.dart';
import 'package:shared_ui/theme/theme_data/bottom_sheet_themes.dart';
import 'package:shared_ui/theme/theme_data/button_themes.dart';
import 'package:shared_ui/theme/theme_data/card_theme.dart';
import 'package:shared_ui/theme/theme_data/checkbox_themes.dart';
import 'package:shared_ui/theme/theme_data/date_picker_themes.dart';
import 'package:shared_ui/theme/theme_data/dialog_themes.dart';
import 'package:shared_ui/theme/theme_data/drawer_themes.dart';
import 'package:shared_ui/theme/theme_data/dropdown_menu_themes.dart';
import 'package:shared_ui/theme/theme_data/floating_action_button_themes.dart';
import 'package:shared_ui/theme/theme_data/icon_button_themes.dart';
import 'package:shared_ui/theme/theme_data/icon_themes.dart';
import 'package:shared_ui/theme/theme_data/input_decoration_themes.dart';
import 'package:shared_ui/theme/theme_data/list_tile_themes.dart';
import 'package:shared_ui/theme/theme_data/navigation_bar_themes.dart';
import 'package:shared_ui/theme/theme_data/radio_themes.dart';
import 'package:shared_ui/theme/theme_data/scrollbar_themes.dart';
import 'package:shared_ui/theme/theme_data/searchbar_themes.dart';
import 'package:shared_ui/theme/theme_data/snack_bar_themes.dart';
import 'package:shared_ui/theme/theme_data/switch_themes.dart';
import 'package:shared_ui/theme/theme_data/tab_bar_themes.dart';
import 'package:shared_ui/theme/theme_data/text_themes.dart';
import 'package:shared_ui/theme/theme_data/time_picker_themes.dart';

part 'app_theme.g.dart';

class AppTheme extends ThemeBase {
  @override
  ColorScheme get colorSchemeLight => ColorScheme(
    primary: AppSemanticColors.light.contentPrimary,
    inversePrimary: AppSemanticColors.light.contentInversed,
    primaryContainer: AppSemanticColors.light.backgroundDisabled,
    onPrimary: AppSemanticColors.light.contentPrimary.withAlpha(255 ~/ 4),
    secondary: AppSemanticColors.light.contentSecondary,
    secondaryContainer: AppSemanticColors.light.contentSecondary,
    onSecondary: AppSemanticColors.light.contentSecondary.withAlpha(255 ~/ 4),
    onSecondaryContainer: AppSemanticColors.light.contentSecondary,
    tertiary: AppSemanticColors.light.contentTertiary,
    tertiaryContainer: AppSemanticColors.light.contentTertiary,
    onTertiary: AppSemanticColors.light.contentTertiary.withAlpha(255 ~/ 4),
    surface: AppSemanticColors.light.backgroundPrimary,
    onSurface: AppSemanticColors.light.backgroundPrimary.withAlpha(255 ~/ 4),
    surfaceContainer: AppSemanticColors.light.backgroundBrand,
    error: AppSemanticColors.light.contentNegative,
    onError: AppSemanticColors.light.contentNegative,
    outline: AppSemanticColors.light.borderBrand,
    shadow: AppEffectStyles.shadowL1Effect0.color,
    scrim: AppSemanticColors.light.overlay50,
    inverseSurface: AppSemanticColors.light.backgroundInversed,
    brightness: Brightness.light,
  );

  @override
  ColorScheme get colorSchemeDark => ColorScheme(
    primary: AppSemanticColors.dark.contentPrimary,
    inversePrimary: AppSemanticColors.dark.contentInversed,
    primaryContainer: AppSemanticColors.dark.contentPrimary,
    onPrimary: AppSemanticColors.dark.contentPrimary.withAlpha(255 ~/ 4),
    secondary: AppSemanticColors.dark.contentSecondary,
    secondaryContainer: AppSemanticColors.dark.contentSecondary,
    onSecondary: AppSemanticColors.dark.contentSecondary.withAlpha(255 ~/ 4),
    tertiary: AppSemanticColors.dark.contentTertiary,
    tertiaryContainer: AppSemanticColors.dark.contentTertiary,
    onTertiary: AppSemanticColors.dark.contentTertiary.withAlpha(255 ~/ 4),
    surface: AppSemanticColors.dark.backgroundPrimary,
    surfaceContainer: AppSemanticColors.dark.backgroundBrand,
    onSurface: AppSemanticColors.dark.backgroundPrimary.withAlpha(255 ~/ 4),
    error: AppSemanticColors.dark.contentNegative,
    onError: AppSemanticColors.dark.contentNegative,
    outline: AppSemanticColors.dark.borderBrand,
    shadow: AppEffectStyles.shadowL1Effect0.color,
    scrim: AppSemanticColors.dark.overlay50,
    inverseSurface: AppSemanticColors.dark.backgroundInversed,
    brightness: Brightness.dark,
  );

  @override
  ThemeData light(BuildContext context) => ThemeData(
    snackBarTheme: SnackBarThemes.light(),
    searchBarTheme: SearchbarThemes.light(),
    dropdownMenuTheme: DropdownMenuThemes.light(),
    tabBarTheme: TabBarThemes.light(),
    floatingActionButtonTheme: FloatingActionButtonThemes.light(),
    extensions: [AppTextTheme.light(), AppImgTheme.light()],
    useMaterial3: true,
    brightness: colorSchemeLight.brightness,
    colorScheme: colorSchemeLight,
    drawerTheme: DrawerThemes.light(),
    textTheme: GoogleFonts.robotoTextTheme(TextThemes.light()),
    cardTheme: CardThemes.light(),
    textButtonTheme: ButtonThemes.textLight(),
    filledButtonTheme: ButtonThemes.filledLight(),
    outlinedButtonTheme: ButtonThemes.outlinedLight(),
    elevatedButtonTheme: ButtonThemes.elevatedLight(),
    iconButtonTheme: IconButtonThemes.light(),
    iconTheme: IconThemes.light(),
    inputDecorationTheme: InputDecorationThemes.light(),
    appBarTheme: AppBarThemes.light(),
    bottomNavigationBarTheme: BottomNavigationBarThemes.light(),
    navigationBarTheme: NavigationBarThemes.light,
    dialogTheme: DialogThemes.light(),
    canvasColor: colorSchemeLight.surface,
    cardColor: colorSchemeLight.surface,
    dividerColor: colorSchemeLight.surfaceContainer,
    disabledColor: colorSchemeLight.primaryContainer,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    primaryColor: colorSchemeLight.primary,
    scaffoldBackgroundColor: colorSchemeLight.surface,
    shadowColor: colorSchemeLight.shadow,
    unselectedWidgetColor: colorSchemeLight.primaryContainer,
    checkboxTheme: CheckboxThemes.light(),
    radioTheme: RadioThemes.light(),
    switchTheme: SwitchThemes.light(),
    listTileTheme: ListTileThemes.light(),
    bottomSheetTheme: BottomSheetThemes.light(),
    datePickerTheme: DatePickerThemes.light(),
    timePickerTheme: TimePickerThemes.light(),
    scrollbarTheme: ScrollbarThemes.light(),
  );

  @override
  ThemeData dark(BuildContext context) => ThemeData(
    snackBarTheme: SnackBarThemes.dark(),
    searchBarTheme: SearchbarThemes.dark(),
    dropdownMenuTheme: DropdownMenuThemes.dark(),
    tabBarTheme: TabBarThemes.dark(),
    floatingActionButtonTheme: FloatingActionButtonThemes.dark(),
    extensions: [AppTextTheme.dark(), AppImgTheme.dark()],
    useMaterial3: true,
    brightness: colorSchemeDark.brightness,
    colorScheme: colorSchemeDark,
    drawerTheme: DrawerThemes.dark(),
    textTheme: GoogleFonts.robotoTextTheme(TextThemes.dark()),
    cardTheme: CardThemes.dark(),
    textButtonTheme: ButtonThemes.textDark(),
    filledButtonTheme: ButtonThemes.filledDark(),
    outlinedButtonTheme: ButtonThemes.outlinedDark(),
    elevatedButtonTheme: ButtonThemes.elevatedDark(),
    iconButtonTheme: IconButtonThemes.dark(),
    iconTheme: IconThemes.dark(),
    inputDecorationTheme: InputDecorationThemes.dark(),
    appBarTheme: AppBarThemes.dark(),
    bottomNavigationBarTheme: BottomNavigationBarThemes.dark(),
    navigationBarTheme: NavigationBarThemes.dark,
    dialogTheme: DialogThemes.dark(),
    cardColor: colorSchemeDark.surface,
    dividerColor: colorSchemeDark.surfaceContainer,
    disabledColor: colorSchemeDark.primaryContainer,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    primaryColor: colorSchemeDark.primary,
    scaffoldBackgroundColor: colorSchemeDark.surface,
    shadowColor: colorSchemeDark.shadow,
    unselectedWidgetColor: colorSchemeDark.primaryContainer,
    checkboxTheme: CheckboxThemes.dark(),
    radioTheme: RadioThemes.dark(),
    switchTheme: SwitchThemes.dark(),
    listTileTheme: ListTileThemes.dark(),
    bottomSheetTheme: BottomSheetThemes.dark(),
    datePickerTheme: DatePickerThemes.dark(),
    timePickerTheme: TimePickerThemes.dark(),
    scrollbarTheme: ScrollbarThemes.light(),
  );
}

@Riverpod(keepAlive: true)
ThemeBase theme(Ref ref) {
  return AppTheme();
}
