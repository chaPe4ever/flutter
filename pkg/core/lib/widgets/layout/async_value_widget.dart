import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Generic AsyncValueWidget to work with values of type T
class AsyncValueWidget<T> extends StatelessWidget {
  /// Constructor
  const AsyncValueWidget({
    required this.value,
    required this.data,
    this.errorWidgetCb,
    this.loadingWidget,
    this.skipLoadingOnReload = true,
    this.skipLoadingOnRefresh = true,
    this.skipError = false,
    super.key,
  });

  /// Loading widget
  final Widget? loadingWidget;

  /// Error widget
  final Widget Function(Object e, StackTrace st)? errorWidgetCb;

  /// input async value
  final AsyncValue<T> value;

  /// output builder function
  final Widget Function(T) data;

  /// - [skipLoadingOnReload] (false by default) customizes whether loading
  ///   should be invoked if a provider rebuilds because of [Ref.watch].
  ///   In that situation, will try to invoke either error/data
  ///   with the previous state.
  final bool skipLoadingOnReload;

  /// - [skipLoadingOnRefresh] (true by default) controls whether loading
  ///   should be invoked if a provider rebuilds because of [Ref.refresh]
  ///   or [Ref.invalidate].
  ///   In that situation, will try to invoke either error/data
  ///   with the previous state.
  final bool skipLoadingOnRefresh;

  /// - [skipError] (false by default) decides whether to invoke [data] instead
  ///   of error if a previous [value] is available.
  final bool skipError;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnReload: skipLoadingOnReload,
      skipLoadingOnRefresh: true, // skipLoadingOnRefresh,
      skipError: skipError,
      data: data,
      loading: () =>
          loadingWidget ?? const Center(child: CircularProgressIndicator()),
      error:
          errorWidgetCb ??
          (e, st) => kDebugMode
              ? Scaffold(
                  body: Center(
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.all(3),
                      height: context.height * 0.5,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          'ERROR_MESSAGE: ${e is CoreException ? e.messageKey.tr() : e}\nSTACKTRACE: ${e is CoreException ? e.st : st}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
    );
  }
}
