import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

extension WidgetRefEX on WidgetRef {
  void listenAndShowSnackBarOnError<T>(
    ProviderListenable<AsyncValue<T>> provider, {
    BuildContext? context,
    VoidCallback? onError,
  }) =>
      listen(provider, (previousState, state) {
        if (state.hasError) {
          onError?.call();
        }
        if (!state.isLoading && state.hasError) {
          final e = state.error;
          final coreEx = e?.toCoreException() ?? UnknownCoreException();
          final text = switch (FlavorHelper.currentFlavor) {
            FlavorEnum.stg =>
              coreEx.messageKey.tr().append('\nError: ${coreEx.innerError}'),
            FlavorEnum.prod || FlavorEnum.dev => coreEx.messageKey.tr(),
          };

          context ??
              this.context.showSnackBar(
                    text: text,
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

      await context.showCustomDialog<void>(
        child: Text(customTitle ?? fallbackTitle),
      );
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
