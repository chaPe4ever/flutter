import 'package:flutter/material.dart';

class IconButtonThemes {
  static IconButtonThemeData light() => IconButtonThemeData(
    style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    ),
  );

  static IconButtonThemeData dark() => IconButtonThemeData(
    style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    ),
  );
}
