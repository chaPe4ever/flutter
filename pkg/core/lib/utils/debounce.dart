import 'dart:async';

import 'package:flutter/material.dart';

/// Debouncing is a programming pattern or a technique to restrict the
/// calling of a time-consuming function frequently, by delaying the execution
/// of the function until a specified time to avoid unnecessary CPU cycles,
/// and API calls and improve performance.
class Debounce {
  const Debounce({this.duration = const Duration(milliseconds: 230)});

  static Timer? _timer;

  final Duration duration;

  /// Dart callable method
  void call<R extends Object?>(
    FutureOr<R> Function() callback, {
    Duration? duration,
  }) {
    cancel();
    _timer = Timer(duration ?? this.duration, callback);
  }

  void cancel() {
    _timer?.cancel();
  }
}

typedef VoidCallbackDebounce = VoidCallback;

/// Creates a debounced callback that will be called only once after the
/// Create an instance of [Debounce] and pass it to the [debounce] parameter
/// if you want to customize the duration of the debounce and you required one
/// debounced instance for multiple calls.
VoidCallbackDebounce? createDebouncedCallback(
  VoidCallback? onTap, {
  Debounce? debounce = const Debounce(duration: Duration(milliseconds: 180)),
}) {
  if (onTap == null) return null;
  return () => debounce?.call(onTap);
}
