import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/app_radius.dart';

void main() {
  group('AppRadius', () {
    test('defines expected circular radii', () {
      expect(AppRadius.xxs, const Radius.circular(2));
      expect(AppRadius.xs, const Radius.circular(4));
      expect(AppRadius.s, const Radius.circular(8));
      expect(AppRadius.m, const Radius.circular(12));
      expect(AppRadius.l, const Radius.circular(16));
      expect(AppRadius.pill, const Radius.circular(999));
      expect(AppRadius.circle, const Radius.circular(50));
    });
  });
}
