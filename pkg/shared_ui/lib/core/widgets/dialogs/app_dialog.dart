import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

enum AppDialogType { primary, secondary, danger }

class AppDialog extends StatelessWidget {
  const AppDialog._(
    this._type, {
    required this.title,
    super.key,
    this.content,
    this.secondaryText,
    this.primaryText,
    this.onSecondaryTap,
    this.onPrimaryTap,
    this.dangerText,
    this.onDangerTap,
  });

  factory AppDialog.primary({
    required String title,
    required String primaryText,
    String? content,
    VoidCallback? onPrimaryTap,
    Key? key,
  }) => AppDialog._(
    key: key,
    AppDialogType.primary,
    title: title,
    content: content,
    primaryText: primaryText,
    onPrimaryTap: onPrimaryTap,
  );

  factory AppDialog.secondary({
    required String title,
    required String primaryText,
    required String secondaryText,
    String? content,
    VoidCallback? onPrimaryTap,
    VoidCallback? onSecondaryTap,
    Key? key,
  }) => AppDialog._(
    key: key,
    AppDialogType.secondary,
    title: title,
    content: content,
    primaryText: primaryText,
    onPrimaryTap: onPrimaryTap,
    secondaryText: secondaryText,
    onSecondaryTap: onSecondaryTap,
  );

  factory AppDialog.danger({
    required String title,
    required String secondaryText,
    required String dangerText,
    String? content,
    VoidCallback? onSecondaryTap,
    VoidCallback? onDangerTap,
    Key? key,
  }) => AppDialog._(
    key: key,
    AppDialogType.danger,
    title: title,
    content: content,
    secondaryText: secondaryText,
    dangerText: dangerText,
    onSecondaryTap: onSecondaryTap,
    onDangerTap: onDangerTap,
  );

  final String title;
  final String? content;
  final String? secondaryText;
  final String? primaryText;
  final String? dangerText;
  final VoidCallback? onSecondaryTap;
  final VoidCallback? onPrimaryTap;
  final VoidCallback? onDangerTap;
  final AppDialogType _type;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      title: TextHeadline.s(title),
      content: content != null ? TextBody.m(content!) : null,
      actions: [
        SpacedRow(
          spacing: AppSpacing.contentM,
          children: switch (_type) {
            AppDialogType.primary => [
              if (primaryText != null)
                AppButton.primary(
                  onTap: onPrimaryTap ?? context.navigatorPop,
                  label: primaryText ?? '',
                ),
            ],
            AppDialogType.secondary => [
              if (secondaryText != null && primaryText != null) ...[
                AppButton.secondary(
                  onTap: onSecondaryTap ?? context.navigatorPop,
                  label: secondaryText ?? '',
                ),
                AppButton.primary(
                  onTap: onPrimaryTap ?? context.navigatorPop,
                  label: primaryText ?? '',
                ),
              ],
            ],
            AppDialogType.danger => [
              if (dangerText != null && secondaryText != null) ...[
                AppButton.danger(
                  onTap: onDangerTap ?? context.navigatorPop,
                  label: dangerText ?? '',
                ),
                AppButton.secondary(
                  onTap: onSecondaryTap ?? context.navigatorPop,
                  label: secondaryText ?? '',
                ),
              ],
            ],
          },
        ),
      ],
    );
  }
}
