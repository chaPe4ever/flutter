import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/app_spacing.dart';

void main() {
  group('AppSpacing', () {
    test('content and section constants are positive', () {
      expect(AppSpacing.contentXS, greaterThan(0));
      expect(AppSpacing.contentS, greaterThan(0));
      expect(AppSpacing.contentM, greaterThan(0));
      expect(AppSpacing.contentMPlus, greaterThan(AppSpacing.contentM));
      expect(AppSpacing.contentL, greaterThan(0));
      expect(AppSpacing.contentXL, greaterThan(0));
      expect(AppSpacing.sectionXS, greaterThan(0));
      expect(AppSpacing.sectionS, greaterThan(0));
      expect(AppSpacing.sectionM, greaterThan(0));
      expect(AppSpacing.sectionL, greaterThan(0));
      expect(AppSpacing.sectionXL, greaterThan(0));
      expect(AppSpacing.deviderHeight, greaterThan(0));
    });
  });
}
