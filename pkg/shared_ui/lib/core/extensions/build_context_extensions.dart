import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

extension BuildContextEx on BuildContext {
  PlatformTextStyles get textStyles =>
      themeData.extension<AppTextTheme>()!.textStyles;

  SemanticColors get colors => switch (themeBrightness) {
        Brightness.dark => AppSemanticColors.dark,
        Brightness.light => AppSemanticColors.light,
      };

  @Deprecated(
    'Use one of [showDialogPrimary, showDialogSecondary, showDialogDanger]',
  )
  Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Key? key,
  }) async =>
      showDialog<T?>(
        context: this,
        barrierDismissible: barrierDismissible,
        routeSettings: const RouteSettings(name: 'AppDialog'),
        builder: (BuildContext context) => child,
      );

  Future<T?> showDialogPrimary<T>({
    required String title,
    required String primaryText,
    VoidCallback? onPrimaryTap,
    String? content,
    bool barrierDismissible = true,
    Key? key,
  }) async =>
      showDialog<T?>(
        context: this,
        barrierDismissible: barrierDismissible,
        routeSettings: const RouteSettings(name: 'AppDialog.primary'),
        builder: (BuildContext context) => AppDialog.primary(
          key: key,
          title: title,
          content: content,
          primaryText: primaryText,
          onPrimaryTap: onPrimaryTap,
        ),
      );

  Future<T?> showDialogSecondary<T>({
    required String title,
    required String primaryText,
    required String secondaryText,
    VoidCallback? onPrimaryTap,
    VoidCallback? onSecondaryTap,
    String? content,
    bool barrierDismissible = true,
    Key? key,
  }) async =>
      showDialog<T?>(
        context: this,
        barrierDismissible: barrierDismissible,
        routeSettings: const RouteSettings(name: 'AppDialog.secondary'),
        builder: (BuildContext context) => AppDialog.secondary(
          key: key,
          title: title,
          content: content,
          primaryText: primaryText,
          onPrimaryTap: onPrimaryTap,
          secondaryText: secondaryText,
          onSecondaryTap: onSecondaryTap,
        ),
      );

  Future<T?> showDialogDanger<T>({
    required String title,
    required String dangerText,
    required String secondaryText,
    VoidCallback? onDangerTap,
    VoidCallback? onSecondaryTap,
    String? content,
    bool barrierDismissible = true,
    Key? key,
  }) async =>
      showDialog<T?>(
        context: this,
        barrierDismissible: barrierDismissible,
        routeSettings: const RouteSettings(name: 'AppDialog.danger'),
        builder: (BuildContext context) => AppDialog.danger(
          key: key,
          title: title,
          content: content,
          dangerText: dangerText,
          onDangerTap: onDangerTap,
          secondaryText: secondaryText,
          onSecondaryTap: onSecondaryTap,
        ),
      );

  void showSnackBar({
    required String text,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionTap,
    Key? key,
  }) =>
      ScaffoldMessenger.maybeOf(this)
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            action: actionLabel == null || onActionTap == null
                ? null
                : SnackBarAction(
                    label: actionLabel,
                    onPressed: onActionTap,
                  ),
            content: TextBody.m(text, color: colors.backgroundSnackbar),
            duration: duration,
            key: key,
          ),
        );

  void showSnackBarError(
    CoreException e, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionTap,
    Key? key,
  }) =>
      ScaffoldMessenger.maybeOf(this)
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            action: actionLabel == null || onActionTap == null
                ? null
                : SnackBarAction(
                    label: actionLabel,
                    onPressed: onActionTap,
                  ),
            content:
                TextBody.m(e.messageKey.tr(), color: colors.backgroundSnackbar),
            duration: duration,
            key: key,
          ),
        );

  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool useRootNavigator = true,
    bool isDismissible = true,
  }) async {
    return showModalBottomSheet<T>(
      context: this,
      isDismissible: isDismissible,
      useRootNavigator: useRootNavigator,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: height * 0.35,
            maxHeight: height * 0.6,
          ),
          child: Padding(
            padding: AppPadding.mobilePage,
            child: child,
          ),
        );
      },
    );
  }
}
