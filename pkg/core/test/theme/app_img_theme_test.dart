import 'package:core/theme/app_img_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppImgTheme', () {
    test('light factory uses black by default', () {
      final theme = AppImgTheme.light();
      expect(theme.color, Colors.black);
      expect(theme.size, 14.0);
    });

    test('dark factory uses white by default', () {
      final theme = AppImgTheme.dark();
      expect(theme.color, Colors.white);
      expect(theme.size, 14.0);
    });

    test('copyWith overrides provided fields', () {
      final original = AppImgTheme.light(defColor: Colors.red, size: 10);
      final copied = original.copyWith(color: Colors.green, size: 20);

      expect(copied.color, Colors.green);
      expect(copied.size, 20);
    });

    test('copyWith keeps unchanged fields', () {
      final original = AppImgTheme.light(defColor: Colors.red, size: 10);
      final copied = original.copyWith();

      expect(copied.color, Colors.red);
      expect(copied.size, 10);
    });

    test('lerp returns this when other is not AppImgTheme', () {
      final theme = AppImgTheme.light();
      final result = theme.lerp(null, 0.5);

      expect(result, theme);
    });

    test('lerp interpolates color toward other theme', () {
      final start = AppImgTheme.light();
      final end = AppImgTheme.light(defColor: Colors.white);

      final mid = start.lerp(end, 0.5) as AppImgTheme;

      expect(mid.color, Color.lerp(Colors.black, Colors.white, 0.5));
      expect(mid.size, start.size);
    });
  });
}
