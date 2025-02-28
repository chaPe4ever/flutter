import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

enum AppButtonType {
  primary,
  secondary,
  danger,
  text,
}

class AppButton extends ElevatedButtonBase {
  const AppButton._({
    required super.label,
    required this.type,
    super.key,
    super.onTap,
    super.leading,
    super.trailing,
    super.fixedSize,
  });

  factory AppButton.primary({
    required String label,
    Key? key,
    VoidCallback? onTap,
    IconBuilder? leading,
    IconBuilder? trailing,
    Size? fixedSize,
  }) =>
      AppButton._(
        label: label,
        type: AppButtonType.primary,
        key: key,
        onTap: onTap,
        leading: leading,
        trailing: trailing,
        fixedSize: fixedSize,
      );

  factory AppButton.secondary({
    required String label,
    Key? key,
    VoidCallback? onTap,
    IconBuilder? leading,
    IconBuilder? trailing,
    Size? fixedSize,
  }) =>
      AppButton._(
        label: label,
        type: AppButtonType.secondary,
        key: key,
        onTap: onTap,
        leading: leading,
        trailing: trailing,
        fixedSize: fixedSize,
      );

  factory AppButton.danger({
    required String label,
    Key? key,
    VoidCallback? onTap,
    IconBuilder? leading,
    IconBuilder? trailing,
    Size? fixedSize,
  }) =>
      AppButton._(
        label: label,
        type: AppButtonType.danger,
        key: key,
        onTap: onTap,
        fixedSize: fixedSize,
        leading: leading,
        trailing: trailing,
      );

  factory AppButton.text({
    required String label,
    Key? key,
    VoidCallback? onTap,
  }) =>
      AppButton._(
        label: label,
        type: AppButtonType.text,
        key: key,
        onTap: onTap,
      );

  final AppButtonType type;

  @override
  EdgeInsets? padding(BuildContext context) {
    return EdgeInsets.all(AppSpacing.contentMPlus);
  }

  @override
  Color? childElementColor(BuildContext context) {
    return switch (type) {
      AppButtonType.primary => context.colors.contentButtonPrimary,
      AppButtonType.secondary => context.colors.borderSecondary,
      AppButtonType.danger => context.colors.contentButtonPrimary,
      AppButtonType.text => context.colors.contentBrand,
    };
  }

  @override
  Color? disabledChildElementColor(BuildContext context) {
    return switch (type) {
      AppButtonType.primary => context.colors.contentPrimary,
      AppButtonType.secondary => context.colors.backgroundDisabled,
      AppButtonType.danger => context.colors.contentPrimary,
      AppButtonType.text => context.colors.backgroundDisabled,
    };
  }

  @override
  Color? hoverChildElementColor(BuildContext context) {
    return switch (type) {
      AppButtonType.text => context.colors.contentLinkHover,
      AppButtonType.secondary => context.colors.contentFocused,
      _ => childElementColor(context),
    };
  }

  @override
  Color? disabledColor(BuildContext context) {
    return switch (type) {
      AppButtonType.primary => context.colors.backgroundDisabled,
      AppButtonType.secondary => Colors.transparent,
      AppButtonType.danger => context.colors.backgroundDisabled,
      AppButtonType.text => Colors.transparent,
    };
  }

  @override
  Color? backgroundColor(BuildContext context) {
    return switch (type) {
      AppButtonType.primary => context.colors.backgroundBrand,
      AppButtonType.secondary => Colors.transparent,
      AppButtonType.danger => context.colors.backgroundNegative,
      AppButtonType.text => Colors.transparent,
    };
  }

  @override
  Color? focusColor(BuildContext context) {
    return switch (type) {
      AppButtonType.primary => context.colors.backgroundPressed,
      AppButtonType.secondary => context.colors.borderFocused,
      AppButtonType.danger => context.colors.borderFocused,
      AppButtonType.text => Colors.transparent,
    };
  }

  @override
  Color? hoverColor(BuildContext context) {
    return switch (type) {
      AppButtonType.primary => context.colors.contentLinkHover,
      AppButtonType.secondary => Colors.transparent,
      AppButtonType.danger => context.colors.backgroundNegative,
      AppButtonType.text => Colors.transparent,
    };
  }

  @override
  Color? errorColor(BuildContext context) {
    return switch (type) {
      AppButtonType.primary => context.colors.backgroundNegative,
      AppButtonType.secondary => context.colors.backgroundNegative,
      AppButtonType.danger => context.colors.backgroundNegative,
      AppButtonType.text => context.colors.backgroundNegative,
    };
  }

  @override
  Color? pressedColor(BuildContext context) {
    return switch (type) {
      AppButtonType.primary => context.colors.contentLinkPressed,
      AppButtonType.secondary => context.colors.backgroundPressed,
      AppButtonType.danger => context.colors.backgroundNegative,
      AppButtonType.text => context.colors.backgroundPressed,
    };
  }

  @override
  Color? selectedColor(BuildContext context) {
    return switch (type) {
      AppButtonType.primary => context.colors.backgroundSelected,
      AppButtonType.secondary => context.colors.backgroundSelected,
      AppButtonType.danger => context.colors.backgroundSelected,
      AppButtonType.text => Colors.transparent,
    };
  }

  @override
  BorderSide defaultBorder(BuildContext context) {
    return switch (type) {
      AppButtonType.primary ||
      AppButtonType.danger ||
      AppButtonType.text =>
        super.defaultBorder(context),
      AppButtonType.secondary => BorderSide(
          color: context.colors.borderSecondary,
        ),
    };
  }

  @override
  BorderSide focusedBorder(BuildContext context) {
    return switch (type) {
      AppButtonType.primary ||
      AppButtonType.danger ||
      AppButtonType.text =>
        super.focusedBorder(context),
      AppButtonType.secondary => BorderSide(
          color: context.colors.borderBrand,
        ),
    };
  }

  @override
  BorderSide hoverBorder(BuildContext context) {
    return switch (type) {
      AppButtonType.primary => super.hoverBorder(context),
      AppButtonType.secondary => BorderSide(
          color: context.colors.contentFocused,
        ),
      AppButtonType.danger => BorderSide(
          color: context.colors.borderNegative,
        ),
      AppButtonType.text => BorderSide.none
    };
  }

  @override
  BorderSide disabledBorder(BuildContext context) {
    return switch (type) {
      AppButtonType.primary ||
      AppButtonType.danger =>
        super.disabledBorder(context),
      AppButtonType.secondary => BorderSide(
          color: context.colors.borderDisabled,
        ),
      AppButtonType.text => BorderSide.none
    };
  }
}
