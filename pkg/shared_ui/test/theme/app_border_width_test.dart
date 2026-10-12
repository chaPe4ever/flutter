import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/app_border_width.dart';

void main() {
  group('AppBorderWidth', () {
    test('widths are ordered ascending', () {
      expect(AppBorderWidth.xs, 1.0);
      expect(AppBorderWidth.s, 1.5);
      expect(AppBorderWidth.m, 2.0);
      expect(AppBorderWidth.l, 4.0);
      expect(AppBorderWidth.xl, 8.0);
      expect(AppBorderWidth.xs, lessThan(AppBorderWidth.s));
      expect(AppBorderWidth.l, lessThan(AppBorderWidth.xl));
    });
  });
}
