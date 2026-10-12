import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/app_theme.dart';
import 'package:shared_ui/theme/pallete/app_semantic_colors.dart';

import '../shared/provider_container.dart';
import '../shared/pump_shared_ui_widget.dart';
import 'theme_data/theme_data_test_helpers.dart';

void main() {
  group('AppTheme', () {
    test('colorSchemeLight uses light semantic colors', () {
      final scheme = AppTheme().colorSchemeLight;
      expect(scheme.brightness, Brightness.light);
      expect(scheme.primary, AppSemanticColors.light.contentPrimary);
      expect(scheme.surface, AppSemanticColors.light.backgroundPrimary);
    });

    test('colorSchemeDark uses dark semantic colors', () {
      final scheme = AppTheme().colorSchemeDark;
      expect(scheme.brightness, Brightness.dark);
      expect(scheme.primary, AppSemanticColors.dark.contentPrimary);
      expect(scheme.surface, AppSemanticColors.dark.backgroundPrimary);
    });

    test('themePod returns AppTheme', () {
      final container = makeProviderContainer();
      expect(container.read(themePod), isA<AppTheme>());
    });

    testWidgets('light() builds a light ThemeData', (tester) async {
      await pumpSharedUiWidget(
        tester,
        child: const SizedBox.shrink(key: Key('theme-probe')),
      );
      final context = tester.element(find.byKey(const Key('theme-probe')));
      expect(Theme.of(context).brightness, Brightness.light);
      expect(Theme.of(context).colorScheme.brightness, Brightness.light);
      expect(Theme.of(context).useMaterial3, isTrue);
    });

    testWidgets('dark() builds a dark ThemeData', (tester) async {
      await pumpSharedUiWidget(
        tester,
        useDarkTheme: true,
        child: const SizedBox.shrink(key: Key('theme-probe')),
      );
      final context = tester.element(find.byKey(const Key('theme-probe')));
      expect(Theme.of(context).brightness, Brightness.dark);
      expect(Theme.of(context).colorScheme.brightness, Brightness.dark);
    });

    testWidgets('light ThemeData resolves widget-state sub-themes', (
      tester,
    ) async {
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            resolveAppThemeWidgetStates(Theme.of(context));
            return const SizedBox.shrink(key: Key('theme-probe'));
          },
        ),
      );
      expect(find.byKey(const Key('theme-probe')), findsOneWidget);
    });

    testWidgets('dark ThemeData resolves widget-state sub-themes', (
      tester,
    ) async {
      await pumpSharedUiWidget(
        tester,
        useDarkTheme: true,
        child: Builder(
          builder: (context) {
            resolveAppThemeWidgetStates(Theme.of(context));
            return const SizedBox.shrink(key: Key('theme-probe'));
          },
        ),
      );
      expect(find.byKey(const Key('theme-probe')), findsOneWidget);
    });
  });
}
