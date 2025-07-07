import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///
class AsyncValueSliverWidget<T> extends StatelessWidget {
  /// Constructor
  const AsyncValueSliverWidget({
    required this.value,
    required this.data,
    this.loadingWidget,
    this.errorWidgetCb,
    this.skipLoadingOnReload = false,
    this.skipLoadingOnRefresh = true,
    this.skipError = false,
    super.key,
  });

  /// input async value
  final AsyncValue<T> value;

  /// output builder function
  final Widget Function(T) data;

  /// Loading widget
  final Widget? loadingWidget;

  /// Error widget
  final Widget Function(Object e, StackTrace st)? errorWidgetCb;

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
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipError: skipError,
      data: data,
      loading: () =>
          loadingWidget ??
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
      error: (e, st) =>
          errorWidgetCb?.call(e, st) ??
          SliverToBoxAdapter(
            child: kDebugMode
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
                            'ERROR_MESSAGE: ${e is CoreException ? e.messageKey.tr() : e}\n\nSTACKTRACE: $st',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
    );
  }
}
