import 'dart:async';

import 'package:flutter/foundation.dart';

/// Invoked when a callable returns Firebase Functions `unauthenticated`.
///
/// Clients register a handler (typically sign-out) so stale Auth tokens
/// (e.g. leftover Auth-emulator sessions) clear Firebase's local cache.
typedef FunctionsUnauthenticatedHandler = FutureOr<void> Function();

/// Global hook for `functionsFutureTryCatch` auth failures.
abstract final class FunctionsAuthFailureHandler {
  static FunctionsUnauthenticatedHandler? onUnauthenticated;

  @visibleForTesting
  static void reset() {
    onUnauthenticated = null;
  }
}
