import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

enum IconButtonType {
  primary,
  secondary,
  outline,
  negative,
  back,
}

class AppIconButton extends IconButtonBase {
  const AppIconButton._({
    required this.type,
    this.customPadding,
    super.icon,
    super.svg,
    super.key,
    super.onTap,
  });

  factory AppIconButton.primary({
    SvgPicture? svg,
    IconData? icon,
    Key? key,
    VoidCallback? onTap,
    EdgeInsets? customPadding,
  }) {
    return AppIconButton._(
      svg: svg,
      icon: icon,
      key: key,
      onTap: onTap,
      type: IconButtonType.primary,
      customPadding: customPadding,
    );
  }

  factory AppIconButton.ouline({
    SvgPicture? svg,
    IconData? icon,
    Key? key,
    VoidCallback? onTap,
    EdgeInsets? customPadding,
  }) {
    return AppIconButton._(
      svg: svg,
      icon: icon,
      key: key,
      onTap: onTap,
      type: IconButtonType.outline,
      customPadding: customPadding,
    );
  }

  factory AppIconButton.secondary({
    SvgPicture? svg,
    IconData? icon,
    Key? key,
    VoidCallback? onTap,
    EdgeInsets? customPadding,
  }) {
    return AppIconButton._(
      svg: svg,
      icon: icon,
      key: key,
      onTap: onTap,
      type: IconButtonType.secondary,
      customPadding: customPadding,
    );
  }

  factory AppIconButton.negative({
    SvgPicture? svg,
    IconData? icon,
    Key? key,
    VoidCallback? onTap,
  }) {
    return AppIconButton._(
      svg: svg,
      icon: icon,
      key: key,
      onTap: onTap,
      type: IconButtonType.negative,
    );
  }

  factory AppIconButton.back({
    Key? key,
    VoidCallback? onTap,
  }) {
    return AppIconButton._(
      icon: Icons.arrow_back,
      key: key,
      onTap: onTap,
      type: IconButtonType.back,
    );
  }

  final IconButtonType type;
  final EdgeInsets? customPadding;

  @override
  EdgeInsets? padding(BuildContext context) {
    return customPadding ??
        context.responsive(
          const EdgeInsets.all(AppSpacing.contentL),
          s: const EdgeInsets.all(AppSpacing.contentL),
          m: const EdgeInsets.all(AppSpacing.contentXL),
          l: const EdgeInsets.all(AppSpacing.contentXL),
          xl: const EdgeInsets.all(AppSpacing.sectionS),
        );
  }

  @override
  double? size(BuildContext context) {
    return switch (type) {
      IconButtonType.back => context.responsive(
          AppSpacing.sectionS,
          s: AppSpacing.sectionS,
          m: AppSpacing.sectionS,
          l: AppSpacing.sectionM,
          xl: AppSpacing.sectionM,
        ),
      _ => context.responsive(
          AppSpacing.contentXL,
          s: AppSpacing.contentXL,
          m: AppSpacing.contentXL,
          l: AppSpacing.sectionS,
          xl: AppSpacing.sectionS,
        ),
    };
  }

  @override
  Color backgroundColor(BuildContext context) {
    return switch (type) {
      IconButtonType.primary => context.colors.backgroundBrand,
      IconButtonType.secondary => context.colors.contentSecondary,
      IconButtonType.outline => context.colors.backgroundBrand,
      IconButtonType.negative => Colors.transparent,
      IconButtonType.back => Colors.transparent,
    };
  }

  @override
  Color disabledColor(BuildContext context) {
    return switch (type) {
      IconButtonType.primary => context.colors.backgroundDisabled,
      IconButtonType.secondary => context.colors.contentDisabled,
      IconButtonType.outline => context.colors.backgroundDisabled,
      IconButtonType.negative => context.colors.contentDisabled,
      IconButtonType.back => context.colors.backgroundDisabled,
    };
  }

  @override
  Color focusColor(BuildContext context) {
    return switch (type) {
      IconButtonType.primary => context.colors.borderFocused,
      IconButtonType.secondary => context.colors.borderFocused,
      IconButtonType.outline => context.colors.borderFocused,
      IconButtonType.negative => Colors.transparent,
      IconButtonType.back => Colors.transparent,
    };
  }

  @override
  Color hoverColor(BuildContext context) {
    return switch (type) {
      IconButtonType.primary => context.colors.backgroundHovered,
      IconButtonType.secondary => context.colors.borderFocused,
      IconButtonType.outline => context.colors.backgroundHovered,
      IconButtonType.negative => Colors.transparent,
      IconButtonType.back => Colors.transparent,
    };
  }

  @override
  Color errorColor(BuildContext context) {
    return switch (type) {
      IconButtonType.primary => context.colors.backgroundNegative,
      IconButtonType.secondary => context.colors.backgroundNegative,
      IconButtonType.outline => context.colors.backgroundNegative,
      IconButtonType.negative => Colors.transparent,
      IconButtonType.back => Colors.transparent,
    };
  }

  @override
  Color pressedColor(BuildContext context) {
    return switch (type) {
      IconButtonType.primary => context.colors.backgroundPressed,
      IconButtonType.secondary => context.colors.backgroundPressed,
      IconButtonType.outline => context.colors.backgroundPressed,
      IconButtonType.negative => Colors.transparent,
      IconButtonType.back => Colors.transparent,
    };
  }

  @override
  Color selectedColor(BuildContext context) {
    return switch (type) {
      IconButtonType.primary => context.colors.backgroundSelected,
      IconButtonType.secondary => context.colors.backgroundSelected,
      IconButtonType.outline => context.colors.backgroundSelected,
      IconButtonType.negative => Colors.transparent,
      IconButtonType.back => Colors.transparent,
    };
  }

  @override
  Color childElementColor(BuildContext context) {
    return switch (type) {
      IconButtonType.primary => context.colors.contentPrimary,
      IconButtonType.secondary => context.colors.contentBrand,
      IconButtonType.outline => context.colors.contentFocused,
      IconButtonType.negative => context.colors.contentNegative,
      IconButtonType.back => context.colors.contentPrimary,
    };
  }

  @override
  Color hoverChildElementColor(BuildContext context) {
    return switch (type) {
      IconButtonType.back => context.colors.backgroundHovered,
      _ => childElementColor(context),
    };
  }
}
