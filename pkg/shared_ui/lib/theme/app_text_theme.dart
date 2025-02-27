import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/theme/pallete/app_semantic_colors.dart';

extension AppTextThemeX on AppTextTheme {
  PlatformTextStyles get textStyles => kIsWeb
      ? web
      : switch (defaultTargetPlatform) {
          TargetPlatform.android => android,
          TargetPlatform.fuchsia => throw UnimplementedError(),
          TargetPlatform.iOS => ios,
          TargetPlatform.linux => throw UnimplementedError(),
          TargetPlatform.macOS => desktop,
          TargetPlatform.windows => desktop,
        };
}

@immutable
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  const AppTextTheme({
    required this.android,
    required this.ios,
    required this.web,
    required this.desktop,
  });

  AppTextTheme.light()
      : this(
          android: PlatformTextStyles.light(
            primaryColor: AppSemanticColors.light.contentPrimary,
            fontFamily: 'Roboto',
          ),
          ios: PlatformTextStyles.light(
            primaryColor: AppSemanticColors.light.contentPrimary,
            fontFamily: 'Roboto',
          ),
          desktop: PlatformTextStyles.light(
            primaryColor: AppSemanticColors.light.contentPrimary,
            fontFamily: 'Roboto',
          ),
          web: PlatformTextStyles.light(
            primaryColor: AppSemanticColors.light.contentPrimary,
            fontFamily: 'Inter',
          ),
        );

  AppTextTheme.dark()
      : this(
          android: PlatformTextStyles.dark(
            primaryColor: AppSemanticColors.dark.contentPrimary,
            fontFamily: 'Roboto',
          ),
          ios: PlatformTextStyles.dark(
            primaryColor: AppSemanticColors.dark.contentPrimary,
            fontFamily: 'Roboto',
          ),
          desktop: PlatformTextStyles.dark(
            primaryColor: AppSemanticColors.dark.contentPrimary,
            fontFamily: 'Roboto',
          ),
          web: PlatformTextStyles.dark(
            primaryColor: AppSemanticColors.dark.contentPrimary,
            fontFamily: 'Inter',
          ),
        );
  final PlatformTextStyles android;
  final PlatformTextStyles ios;
  final PlatformTextStyles web;
  final PlatformTextStyles desktop;

  @override
  AppTextTheme copyWith({
    PlatformTextStyles? android,
    PlatformTextStyles? ios,
    PlatformTextStyles? web,
    PlatformTextStyles? desktop,
  }) {
    return AppTextTheme(
      android: android ?? this.android,
      ios: ios ?? this.ios,
      web: web ?? this.web,
      desktop: desktop ?? this.desktop,
    );
  }

  @override
  AppTextTheme lerp(AppTextTheme? other, double t) {
    if (other is! AppTextTheme) return this;
    return AppTextTheme(
      android: PlatformTextStyles.lerp(android, other.android, t),
      ios: PlatformTextStyles.lerp(ios, other.ios, t),
      web: PlatformTextStyles.lerp(web, other.web, t),
      desktop: PlatformTextStyles.lerp(desktop, other.desktop, t),
    );
  }
}

@immutable
class PlatformTextStyles {
  factory PlatformTextStyles.lerp(
    PlatformTextStyles a,
    PlatformTextStyles b,
    double t,
  ) {
    return PlatformTextStyles._(
      labelM: TextStyle.lerp(a.labelM, b.labelM, t)!,
      labelL: TextStyle.lerp(a.labelL, b.labelL, t)!,
      bodyXS: TextStyle.lerp(a.bodyXS, b.bodyXS, t)!,
      bodyS: TextStyle.lerp(a.bodyS, b.bodyS, t)!,
      bodyM: TextStyle.lerp(a.bodyM, b.bodyM, t)!,
      bodyL: TextStyle.lerp(a.bodyL, b.bodyL, t)!,
      titleM: TextStyle.lerp(a.titleM, b.titleM, t)!,
      titleL: TextStyle.lerp(a.titleL, b.titleL, t)!,
      headlineS: TextStyle.lerp(a.headlineS, b.headlineS, t)!,
      headlineM: TextStyle.lerp(a.headlineM, b.headlineM, t)!,
      headlineL: TextStyle.lerp(a.headlineL, b.headlineL, t)!,
    );
  }
  factory PlatformTextStyles.dark({
    required Color primaryColor,
    required String fontFamily,
  }) {
    return PlatformTextStyles.light(
      primaryColor: primaryColor,
      fontFamily: fontFamily,
    );
  }
  const PlatformTextStyles._({
    required this.labelM,
    required this.labelL,
    required this.bodyXS,
    required this.bodyS,
    required this.bodyM,
    required this.bodyL,
    required this.titleM,
    required this.titleL,
    required this.headlineS,
    required this.headlineM,
    required this.headlineL,
  });

  factory PlatformTextStyles.light({
    required Color primaryColor,
    required String fontFamily,
  }) {
    return PlatformTextStyles._(
      headlineL: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
        height: 1.25,
        letterSpacing: 0,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
        color: primaryColor,
      ),
      headlineM: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
        height: 1.29,
        letterSpacing: 0,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
        color: primaryColor,
      ),
      headlineS: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
        height: 1.33,
        letterSpacing: 0,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
        color: primaryColor,
      ),
      bodyL: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
        height: 1.5,
        letterSpacing: 0.15,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
        color: primaryColor,
      ),
      bodyM: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
        height: 1.43,
        letterSpacing: 0.25,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
        color: primaryColor,
      ),
      bodyS: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
        height: 1.33,
        letterSpacing: 0.4,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
        color: primaryColor,
      ),
      bodyXS: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
        height: 1.2,
        letterSpacing: 0.4,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
        color: primaryColor,
      ),
      titleL: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        height: 1.27,
        letterSpacing: 0,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
        color: primaryColor,
      ),
      titleM: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        height: 1.5,
        letterSpacing: 0.15,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
        color: primaryColor,
      ),
      labelL: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        height: 1.43,
        letterSpacing: 0.1,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
        color: primaryColor,
      ),
      labelM: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        height: 1.14,
        letterSpacing: 1.33,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
        color: primaryColor,
      ),
    );
  }

  final TextStyle labelM;
  final TextStyle labelL;
  final TextStyle bodyXS;
  final TextStyle bodyS;
  final TextStyle bodyM;
  final TextStyle bodyL;
  final TextStyle titleM;
  final TextStyle titleL;
  final TextStyle headlineS;
  final TextStyle headlineM;
  final TextStyle headlineL;
}
