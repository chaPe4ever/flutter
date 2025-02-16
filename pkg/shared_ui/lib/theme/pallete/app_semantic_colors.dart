import 'package:flutter/material.dart';
import 'package:shared_ui/theme/pallete/app_primitive_colors.dart';

abstract class AppSemanticColors {
  const AppSemanticColors._();
  static const SemanticColors light = SemanticColors(
    borderBrand: AppPrimitiveColors.basePurpleRegular,
    borderDisabled: AppPrimitiveColors.baseGrayRegular,
    borderFocused: AppPrimitiveColors.basePurpleRegular,
    borderInversed: AppPrimitiveColors.baseWhiteRegular,
    borderNegative: AppPrimitiveColors.baseRedRegular,
    borderHovered: AppPrimitiveColors.baseGrayLight,
    borderPrimary: AppPrimitiveColors.baseBlackRegular,
    borderPressed: AppPrimitiveColors.baseGrayLight,
    borderSelected: AppPrimitiveColors.baseGrayExtraLight,
    borderSecondary: AppPrimitiveColors.basePurpleRegular,
    borderEnabled: AppPrimitiveColors.baseGrayRegular,
    borderSupport: AppPrimitiveColors.baseGrayLight,
    backgroundBrand: AppPrimitiveColors.basePurpleRegular,
    backgroundDisabled: AppPrimitiveColors.baseGrayRegular,
    backgroundHovered: AppPrimitiveColors.baseGrayLight,
    backgroundInversed: AppPrimitiveColors.baseBlackRegular,
    backgroundNegative: AppPrimitiveColors.baseRedRegular,
    backgroundFocused: AppPrimitiveColors.baseWhiteRegular,
    backgroundPressed: AppPrimitiveColors.baseGrayExtraLight,
    backgroundPrimary: AppPrimitiveColors.baseWhiteRegular,
    backgroundSelected: AppPrimitiveColors.baseGrayExtraLight,
    backgroundSnackbar: AppPrimitiveColors.baseWhiteRegular,
    backgroundSelectedItem: AppPrimitiveColors.basePurpleExtraLight,
    backgroundModalLoading: AppPrimitiveColors.basePurpleExtraLight,
    contentSupport: AppPrimitiveColors.baseGrayRegular,
    contentButtonPrimary: AppPrimitiveColors.baseWhiteRegular,
    contentBrand: AppPrimitiveColors.basePurpleRegular,
    contentDisabled: AppPrimitiveColors.baseGrayRegular,
    contentFocused: AppPrimitiveColors.basePurpleLight,
    contentPressed: AppPrimitiveColors.basePurpleExtraLight,
    contentLink: AppPrimitiveColors.basePurpleRegular,
    contentLinkHover: AppPrimitiveColors.basePurpleLight,
    contentLinkPressed: AppPrimitiveColors.basePurpleExtraLight,
    contentNegative: AppPrimitiveColors.baseRedRegular,
    contentSelected: AppPrimitiveColors.baseBlackLight,
    contentPrimary: AppPrimitiveColors.baseBlackRegular,
    contentInversed: AppPrimitiveColors.baseWhiteRegular,
    contentSecondary: AppPrimitiveColors.baseGrayRegular,
    contentTertiary: AppPrimitiveColors.baseGrayLight,
    contentHovered: AppPrimitiveColors.baseBlackLight,
    contentTabBarSelected: AppPrimitiveColors.basePurpleRegular,
    surface: AppPrimitiveColors.baseWhiteRegular,
    overlay50: AppPrimitiveColors.baseGrayExtraLight,
    overlay50Inverse: AppPrimitiveColors.baseBlackLight,
  );

  static const SemanticColors dark = SemanticColors(
    borderBrand: AppPrimitiveColors.basePurpleRegular,
    borderDisabled: AppPrimitiveColors.baseGrayLight,
    borderFocused: AppPrimitiveColors.basePurpleRegular,
    borderInversed: AppPrimitiveColors.baseWhiteRegular,
    borderNegative: AppPrimitiveColors.baseRedRegular,
    borderHovered: AppPrimitiveColors.baseGrayRegular,
    borderPrimary: AppPrimitiveColors.baseWhiteRegular,
    borderPressed: AppPrimitiveColors.baseGrayRegular,
    borderSelected: AppPrimitiveColors.baseGrayExtraLight,
    borderSecondary: AppPrimitiveColors.baseWhiteRegular,
    borderEnabled: AppPrimitiveColors.baseGrayRegular,
    borderSupport: AppPrimitiveColors.baseGrayLight,
    backgroundBrand: AppPrimitiveColors.basePurpleRegular,
    backgroundDisabled: AppPrimitiveColors.baseGrayLight,
    backgroundHovered: AppPrimitiveColors.baseGrayRegular,
    backgroundInversed: AppPrimitiveColors.baseWhiteRegular,
    backgroundFocused: AppPrimitiveColors.baseBlackLight,
    backgroundNegative: AppPrimitiveColors.baseRedRegular,
    backgroundPressed: AppPrimitiveColors.baseGrayExtraLight,
    backgroundPrimary: AppPrimitiveColors.baseBlackRegular,
    backgroundSelected: AppPrimitiveColors.baseBlackLight,
    backgroundSnackbar: AppPrimitiveColors.baseWhiteRegular,
    backgroundSelectedItem: AppPrimitiveColors.baseBlackLight,
    backgroundModalLoading: AppPrimitiveColors.basePurpleLight,
    contentSupport: AppPrimitiveColors.baseGrayExtraLight,
    contentButtonPrimary: AppPrimitiveColors.baseWhiteRegular,
    contentBrand: AppPrimitiveColors.basePurpleRegular,
    contentDisabled: AppPrimitiveColors.baseGrayLight,
    contentFocused: AppPrimitiveColors.basePurpleLight,
    contentPressed: AppPrimitiveColors.basePurpleExtraLight,
    contentLink: AppPrimitiveColors.basePurpleRegular,
    contentLinkHover: AppPrimitiveColors.basePurpleLight,
    contentLinkPressed: AppPrimitiveColors.basePurpleExtraLight,
    contentNegative: AppPrimitiveColors.baseRedRegular,
    contentSelected: AppPrimitiveColors.baseGrayExtraLight,
    contentPrimary: AppPrimitiveColors.baseWhiteRegular,
    contentInversed: AppPrimitiveColors.baseBlackRegular,
    contentSecondary: AppPrimitiveColors.baseGrayRegular,
    contentTertiary: AppPrimitiveColors.baseGrayLight,
    contentHovered: AppPrimitiveColors.baseGrayExtraLight,
    contentTabBarSelected: AppPrimitiveColors.basePurpleLight,
    surface: AppPrimitiveColors.baseBlackRegular,
    overlay50: AppPrimitiveColors.baseBlackLight,
    overlay50Inverse: AppPrimitiveColors.baseGrayExtraLight,
  );
}

final class SemanticColors {
  const SemanticColors({
    required this.borderSelected,
    required this.borderNegative,
    required this.borderPrimary,
    required this.borderDisabled,
    required this.borderHovered,
    required this.borderFocused,
    required this.borderInversed,
    required this.borderBrand,
    required this.borderPressed,
    required this.borderSecondary,
    required this.borderEnabled,
    required this.borderSupport,
    required this.contentSupport,
    required this.contentButtonPrimary,
    required this.contentLink,
    required this.contentPressed,
    required this.contentFocused,
    required this.contentLinkPressed,
    required this.contentLinkHover,
    required this.contentBrand,
    required this.contentDisabled,
    required this.contentHovered,
    required this.contentInversed,
    required this.contentTertiary,
    required this.contentSecondary,
    required this.contentPrimary,
    required this.contentNegative,
    required this.contentSelected,
    required this.contentTabBarSelected,
    required this.backgroundHovered,
    required this.backgroundPrimary,
    required this.backgroundNegative,
    required this.backgroundInversed,
    required this.backgroundDisabled,
    required this.backgroundSelected,
    required this.backgroundPressed,
    required this.backgroundBrand,
    required this.backgroundFocused,
    required this.backgroundSnackbar,
    required this.backgroundSelectedItem,
    required this.backgroundModalLoading,
    required this.surface,
    required this.overlay50Inverse,
    required this.overlay50,
  });
  final Color borderPrimary;
  final Color borderInversed;
  final Color borderPressed;
  final Color borderBrand;
  final Color borderDisabled;
  final Color borderNegative;
  final Color borderFocused;
  final Color borderSelected;
  final Color borderHovered;
  final Color borderEnabled;
  final Color borderSupport;
  final Color borderSecondary;
  final Color contentSupport;
  final Color contentLink;
  final Color contentLinkHover;
  final Color contentLinkPressed;
  final Color contentPrimary;
  final Color contentInversed;
  final Color contentPressed;
  final Color contentBrand;
  final Color contentDisabled;
  final Color contentNegative;
  final Color contentFocused;
  final Color contentSelected;
  final Color contentTabBarSelected;
  final Color contentHovered;
  final Color contentSecondary;
  final Color contentTertiary;
  final Color contentButtonPrimary;
  final Color backgroundPrimary;
  final Color backgroundInversed;
  final Color backgroundPressed;
  final Color backgroundBrand;
  final Color backgroundDisabled;
  final Color backgroundNegative;
  final Color backgroundFocused;
  final Color backgroundSelected;
  final Color backgroundHovered;
  final Color backgroundSnackbar;
  final Color backgroundSelectedItem;
  final Color backgroundModalLoading;
  final Color surface;
  final Color overlay50Inverse;
  final Color overlay50;
}
