// App padding

import 'package:flutter/widgets.dart';
import 'package:shared_ui/theme/app_spacing.dart';

abstract class AppPadding {
  const AppPadding._();
  static EdgeInsetsGeometry mobilePage = const EdgeInsets.symmetric(
    horizontal: AppSpacing.sectionXS,
  );
  static EdgeInsetsGeometry webPage = const EdgeInsets.symmetric(
    horizontal: AppSpacing.sectionXS,
  );

  static EdgeInsets button = const EdgeInsets.symmetric(
    horizontal: AppSpacing.contentL,
    vertical: AppSpacing.contentM,
  );

  static EdgeInsets buttonBar = const EdgeInsets.all(
    AppSpacing.sectionXS,
  );

  static EdgeInsets buttonBarHorizontal = const EdgeInsets.symmetric(
    horizontal: AppSpacing.sectionXS,
  );

  static EdgeInsets buttonBarVertical = const EdgeInsets.symmetric(
    vertical: AppSpacing.sectionXS,
  );
}
