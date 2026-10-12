import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScreenSizes', () {
    test('defines minimum and maximum height bounds', () {
      expect(ScreenSizes.minHeight, 620);
      expect(ScreenSizes.maxHeight, double.infinity);
    });
  });
}
