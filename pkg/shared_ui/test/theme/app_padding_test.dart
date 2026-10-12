import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/app_padding.dart';
import 'package:shared_ui/theme/app_spacing.dart';

void main() {
  group('AppPadding', () {
    test('page and button paddings use AppSpacing', () {
      expect(
        AppPadding.mobilePage,
        const EdgeInsets.symmetric(horizontal: AppSpacing.sectionXS),
      );
      expect(
        AppPadding.webPage,
        const EdgeInsets.symmetric(horizontal: AppSpacing.sectionXS),
      );
      expect(
        AppPadding.button,
        const EdgeInsets.symmetric(
          horizontal: AppSpacing.contentL,
          vertical: AppSpacing.contentM,
        ),
      );
      expect(AppPadding.buttonBar, const EdgeInsets.all(AppSpacing.sectionXS));
      expect(
        AppPadding.buttonBarHorizontal,
        const EdgeInsets.symmetric(horizontal: AppSpacing.sectionXS),
      );
      expect(
        AppPadding.buttonBarVertical,
        const EdgeInsets.symmetric(vertical: AppSpacing.sectionXS),
      );
    });
  });
}
