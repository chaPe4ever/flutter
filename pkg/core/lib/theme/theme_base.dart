import 'package:flutter/material.dart';

/// Theme interface
abstract class ThemeBase {
  /// Define your app's light colors
  ColorScheme get colorSchemeLight;

  /// Define your app's dark colors
  ColorScheme get colorSchemeDark;

  /// The light theme data of the app
  ThemeData light(BuildContext context);

  /// The dark theme data of the app
  ThemeData dark(BuildContext context);
}
