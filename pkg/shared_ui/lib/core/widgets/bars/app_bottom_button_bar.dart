import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

enum AppButtonBarType { single, double }

class AppBottomButtonBar extends StatelessWidget {
  const AppBottomButtonBar._(
    this._type, {
    required this.labelPrimary,
    required this.onPrimaryTap,
    this.labelSecondary,
    super.key,
    this.onSecondaryTap,
    this.padding,
  });

  factory AppBottomButtonBar.single({
    required String label,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    Key? key,
  }) {
    return AppBottomButtonBar._(
      AppButtonBarType.single,
      key: key,
      padding: padding,
      labelPrimary: label,
      onPrimaryTap: onTap,
    );
  }

  factory AppBottomButtonBar.double({
    required String labelPrimary,
    required String labelSecondary,
    VoidCallback? onPrimaryTap,
    VoidCallback? onSecondaryTap,
    EdgeInsetsGeometry? padding,
    Key? key,
  }) {
    return AppBottomButtonBar._(
      AppButtonBarType.double,
      key: key,
      padding: padding,
      labelPrimary: labelPrimary,
      labelSecondary: labelSecondary,
      onPrimaryTap: onPrimaryTap,
      onSecondaryTap: onSecondaryTap,
    );
  }

  final AppButtonBarType _type;
  final String labelPrimary;
  final String? labelSecondary;
  final VoidCallback? onPrimaryTap;
  final VoidCallback? onSecondaryTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundPrimary,
      padding: padding ?? AppPadding.buttonBar,
      child: switch (_type) {
        AppButtonBarType.single => AppButton.primary(
            label: labelPrimary,
            onTap: onPrimaryTap,
          ),
        AppButtonBarType.double => SpacedRow(
            spacing: AppSpacing.sectionXS,
            children: [
              Expanded(
                child: AppButton.secondary(
                  label: labelSecondary ?? '',
                  onTap: onSecondaryTap,
                ),
              ),
              Expanded(
                flex: 2,
                child: AppButton.primary(
                  label: labelPrimary,
                  onTap: onPrimaryTap,
                ),
              ),
            ],
          ),
      },
    );
  }
}
