import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/app_text_theme.dart';
import 'package:shared_ui/theme/pallete/app_semantic_colors.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  group('platformTextStylesFor', () {
    test('returns web styles when isWeb is true', () {
      final theme = AppTextTheme.light();
      expect(
        platformTextStylesFor(theme, isWeb: true),
        same(theme.web),
      );
    });
  });

  group('AppTextTheme.textStyles', () {
    test('returns android styles', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final theme = AppTextTheme.light();
      expect(theme.textStyles, same(theme.android));
    });

    test('returns iOS styles', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final theme = AppTextTheme.light();
      expect(theme.textStyles, same(theme.ios));
    });

    test('returns desktop styles on macOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      final theme = AppTextTheme.light();
      expect(theme.textStyles, same(theme.desktop));
    });

    test('returns desktop styles on windows', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      final theme = AppTextTheme.light();
      expect(theme.textStyles, same(theme.desktop));
    });

    test('throws on linux', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      expect(
        () => AppTextTheme.light().textStyles,
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('throws on fuchsia', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
      expect(
        () => AppTextTheme.light().textStyles,
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('AppTextTheme', () {
    test('dark() uses dark semantic colors and Inter on web', () {
      final theme = AppTextTheme.dark();
      expect(
        theme.android.bodyM.color,
        AppSemanticColors.dark.contentPrimary,
      );
      expect(theme.web.bodyM.fontFamily, 'Inter');
      expect(theme.android.bodyM.fontFamily, 'Roboto');
    });

    test('light() exposes web styles for the web branch', () {
      final theme = AppTextTheme.light();
      expect(theme.web.bodyM.fontFamily, 'Inter');
      expect(
        theme.web.bodyM.color,
        AppSemanticColors.light.contentPrimary,
      );
    });

    test('copyWith keeps existing styles when omitted', () {
      final theme = AppTextTheme.light();
      final copy = theme.copyWith();
      expect(copy.android, same(theme.android));
      expect(copy.ios, same(theme.ios));
      expect(copy.web, same(theme.web));
      expect(copy.desktop, same(theme.desktop));
    });

    test('copyWith replaces provided styles', () {
      final light = AppTextTheme.light();
      final dark = AppTextTheme.dark();
      final copy = light.copyWith(
        android: dark.android,
        ios: dark.ios,
        web: dark.web,
        desktop: dark.desktop,
      );
      expect(copy.android, same(dark.android));
      expect(copy.ios, same(dark.ios));
      expect(copy.web, same(dark.web));
      expect(copy.desktop, same(dark.desktop));
    });

    test('lerp interpolates with another AppTextTheme', () {
      final light = AppTextTheme.light();
      final dark = AppTextTheme.dark();
      final mid = light.lerp(dark, 0.5);
      expect(mid, isA<AppTextTheme>());
      expect(mid.android.bodyM, isA<TextStyle>());
    });

    test('lerp returns this when other is not AppTextTheme', () {
      final theme = AppTextTheme.light();
      expect(theme.lerp(null, 0.4), same(theme));
    });
  });

  group('PlatformTextStyles', () {
    test('dark() delegates to light with the given color', () {
      const color = Color(0xFF112233);
      final styles = PlatformTextStyles.dark(
        primaryColor: color,
        fontFamily: 'Roboto',
      );
      expect(styles.bodyM.color, color);
      expect(styles.headlineL.fontFamily, 'Roboto');
    });

    test('lerp interpolates text styles', () {
      final a = PlatformTextStyles.light(
        primaryColor: const Color(0xFF000000),
        fontFamily: 'Roboto',
      );
      final b = PlatformTextStyles.dark(
        primaryColor: const Color(0xFFFFFFFF),
        fontFamily: 'Inter',
      );
      final mid = PlatformTextStyles.lerp(a, b, 0.5);
      expect(mid.bodyM, isNot(same(a.bodyM)));
      expect(mid.labelS, isA<TextStyle>());
      expect(mid.headlineL, isA<TextStyle>());
    });
  });
}
