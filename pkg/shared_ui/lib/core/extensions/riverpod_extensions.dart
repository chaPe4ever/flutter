import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

extension WidgetRefEX on WidgetRef {
  void listenAndShowSnackBarOnError<T>(
    ProviderListenable<AsyncValue<T>> provider, {
    BuildContext? context,
  }) =>
      listen(provider, (previousState, state) {
        if (!state.isLoading && state.hasError) {
          final e = state.error;
          context ??
              this.context.showSnackBar(
                    text: e is CoreException
                        ? e.messageKey.tr()
                        : 'unknown_core_exception_failure'.tr(),
                  );
        }
      });
}

extension AsyncValueUiX<T> on AsyncValue<T> {
  Future<void> showAlertDialogOnError(
    BuildContext context, {
    String? customTitle,
  }) async {
    if (!isLoading && hasError) {
      final fallbackTitle = error is CoreException
          ? (error! as CoreException).messageKey.tr()
          : 'unknown_core_exception_failure'.tr();

      await context.showCustomDialog(child: Text(customTitle ?? fallbackTitle));
    }
  }

  void showSnackBarOnError(BuildContext context) {
    if (!isLoading && hasError) {
      context.showSnackBar(
        text: error is CoreException
            ? (error! as CoreException).messageKey.tr()
            : 'unknown_core_exception_failure'.tr(),
      );
    }
  }
}
