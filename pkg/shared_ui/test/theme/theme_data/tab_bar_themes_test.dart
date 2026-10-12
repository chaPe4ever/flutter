import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/tab_bar_themes.dart';

void main() {
  group('TabBarThemes', () {
    test('light and dark return TabBarThemeData', () {
      expect(TabBarThemes.light(), isA<TabBarThemeData>());
      expect(TabBarThemes.dark(), isA<TabBarThemeData>());
    });

    test('RoundedTabIndicator paints without error', () {
      const indicator = RoundedTabIndicator(color: Color(0xFF112233));
      final painter = indicator.createBoxPainter();
      final canvas = Canvas(PictureRecorder());
      painter
        ..paint(
          canvas,
          Offset.zero,
          const ImageConfiguration(size: Size(40, 20)),
        )
        ..dispose();
    });

    test('theme indicator is a RoundedTabIndicator that paints', () {
      final indicator = TabBarThemes.light().indicator;
      expect(indicator, isA<RoundedTabIndicator>());
      final painter = indicator!.createBoxPainter(() {});
      final canvas = Canvas(PictureRecorder());
      painter
        ..paint(
          canvas,
          Offset.zero,
          const ImageConfiguration(size: Size(80, 40)),
        )
        ..dispose();
    });
  });
}
