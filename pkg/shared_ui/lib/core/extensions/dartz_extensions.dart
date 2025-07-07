import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_ui/core/extensions/build_context_extensions.dart';

/// A class that extends the Either class from the dartz package.
extension EitherEx<T> on Either<CoreException, T> {
  /// A cb fnction that handles the data and error and shows a snackbar in
  /// case of an error or return a Widget in case of data.
  Widget whenDataElseSnackbar(
    Widget Function(T) data, {
    required BuildContext context,
  }) => fold(
    (l) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        context.showSnackBar(text: l.messageKey.tr());
      });
      return const SizedBox();
    },
    (r) => data(r),
  );

  /// A cb fnction that handles the data and error, and shows a snackbar in
  /// case of an error.
  FutureOr<void> onDataElseSnackbarCb(
    FutureOr<void> Function(T) data, {
    required BuildContext context,
    FutureOr<void> Function(CoreException l)? onError,
  }) async => fold(
    (l) async {
      await onError?.call(l);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.showSnackBar(text: l.messageKey.tr());
        }
      });
    },
    (r) async => data(r),
  );
}
