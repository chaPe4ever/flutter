import 'package:core/theme/theme_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeBase', () {
    test('implementations expose color schemes and theme data', () {
      final theme = _TestThemeBase();

      expect(theme.colorSchemeLight.brightness, Brightness.light);
      expect(theme.colorSchemeDark.brightness, Brightness.dark);

      final context = _FakeBuildContext();
      expect(theme.light(context).brightness, Brightness.light);
      expect(theme.dark(context).brightness, Brightness.dark);
    });
  });
}

final class _TestThemeBase implements ThemeBase {
  @override
  ColorScheme get colorSchemeLight => const ColorScheme.light();

  @override
  ColorScheme get colorSchemeDark => const ColorScheme.dark();

  @override
  ThemeData light(BuildContext context) =>
      ThemeData(colorScheme: colorSchemeLight);

  @override
  ThemeData dark(BuildContext context) =>
      ThemeData(colorScheme: colorSchemeDark);
}

final class _FakeBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
