import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

extension RiverpodX on Ref {
  /// Cache can be used to cache data for a provided [duration] for an
  /// autoDisposed pod. The return type is of the same type of [cb]. If there
  /// is a request that being involved on the process, you can pass an
  /// optional cancelToken to cancel the request when the pod is being disposed
  T cache<T>(
    T Function() cb, {
    required Duration duration,
    VoidCallback? onDispose,
    VoidCallback? onCancel,
    VoidCallback? onResume,
  }) {
    // get the KeepAliveLink
    final link = keepAlive();
    // a timer to be used by the callbacks below
    Timer? timer;
    // When the provider is destroyed, cancel any dio http request and the timer
    this.onDispose(() {
      timer?.cancel();

      onDispose?.call();
    });
    // When the last listener is removed, start a timer to dispose the cached
    // data
    this.onCancel(() {
      // start a timer with the specified duration
      timer = Timer(duration, link.close);
      onCancel?.call();
    });
    // If the provider is listened again after it was paused, cancel the timer
    this.onResume(() {
      timer?.cancel();
      onResume?.call();
    });

    return cb();
  }

  /// Cache can be used to cache data for a provided [duration] for an
  /// autoDisposed pod. The return type is of the same type of [cb]. The
  /// cache countdown starts immidiately after init and get resets after the
  /// duration has been reached.  If there is a request that being involved on
  /// the process, you can pass an optional cancelToken to cancel the request
  /// when the pod is being disposed. The difference with [cache] is that the
  /// latter gets dispossed only after the last listener has been removed.
  T cacheCountdown<T>(
    T Function() cb, {
    required Duration duration,
    VoidCallback? onDispose,
    VoidCallback? onCancel,
    VoidCallback? onResume,
  }) {
    // get the KeepAliveLink
    final link = keepAlive();

    // a timer to be used by the callbacks below
    Timer? timer;

    timer = Timer(duration, link.close);
    // When the provider is destroyed, cancel any dio http request and the timer
    this.onDispose(() {
      timer?.cancel();

      onDispose?.call();
    });
    // When the last listener is removed, start a timer to dispose the cached
    // data
    this.onCancel(() {
      // start a timer with the specified duration
      timer?.cancel();
      onCancel?.call();
    });
    // If the provider is listened again after it was paused, cancel the timer
    this.onResume(() {
      timer?.cancel();
      onResume?.call();
    });

    return cb();
  }
}

extension WidgetRefX on WidgetRef {
  void listenForError<T>(
    ProviderListenable<AsyncValue<T>> provider, {
    required FutureOr<void> Function(CoreException e) onError,
  }) => listen(provider, (previousState, state) async {
    if (!state.isLoading && state.hasError) {
      final e = state.error;
      await onError(e as CoreException? ?? UnknownCoreException(innerError: e));
    }
  });
}
