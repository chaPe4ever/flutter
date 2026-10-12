import 'dart:async';
import 'dart:isolate';

import 'package:core/core.dart';
import 'package:crashlytics/crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Chooses the throwable Sentry should title an issue with.
///
/// [CoreException] keeps the user-facing key on [CoreException.messageKey] and
/// the original failure on [CoreException.innerError]. Reporting the wrapper
/// makes the issue title that translation key.
@visibleForTesting
({Object throwable, StackTrace? stackTrace}) sentryReport(
  Object error,
  StackTrace? stackTrace,
) {
  if (error is CoreException) {
    final inner = error.innerError;
    if (inner is Object) {
      return (throwable: inner, stackTrace: error.st ?? stackTrace);
    }
  }
  return (throwable: error, stackTrace: stackTrace);
}

///
final class SentryCrashlyticsImpl implements CrashlyticsBase {
  ///
  SentryCrashlyticsImpl();

  @override
  Future<void> setCrashlytics({required bool enabled}) async {
    try {
      if (!enabled) {
        Sentry.bindClient(SentryClient(SentryOptions(dsn: '')));
      }
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> setUserId({required String userId}) async {
    try {
      // TODOCheck if this is the right way to set user id in Sentry
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  void testCrash() {
    if (kDebugMode) {
      Sentry.captureException(
        const UnknownCrashlyticsException(
          messageKey: 'test_crash_key',
          innerMessage: 'Test crash',
        ),
      );
    }
  }

  @override
  Future<void> init() async {
    try {
      final originalOnError = FlutterError.onError;

      // Install a new handler that calls Sentry and then any previous handler
      FlutterError.onError = (FlutterErrorDetails details) {
        // Sentry first
        final report = sentryReport(details.exception, details.stack);
        Sentry.captureException(
          report.throwable,
          stackTrace: report.stackTrace,
        );

        // Then call any previous handler
        originalOnError?.call(details);
      };

      // Same for uncaught async errors
      final originalPlatformHandler = PlatformDispatcher.instance.onError;

      PlatformDispatcher.instance.onError = (error, stack) {
        final report = sentryReport(error, stack);
        Sentry.captureException(
          report.throwable,
          stackTrace: report.stackTrace,
        );
        // call original (if any) so nothing else breaks
        return originalPlatformHandler?.call(error, stack) ?? false;
      };

      //And in spawned isolates:
      Isolate.current.addErrorListener(
        RawReceivePort((List<dynamic> pair) {
          final error = pair.first;
          final stack = StackTrace.fromString(pair.last as String);
          if (error is Object) {
            final report = sentryReport(error, stack);
            Sentry.captureException(
              report.throwable,
              stackTrace: report.stackTrace,
            );
          } else {
            Sentry.captureException(error, stackTrace: stack);
          }
        }).sendPort,
      );
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> captureException(
    dynamic error, {
    StackTrace? stackTrace,
  }) async {
    if (error is Object) {
      final report = sentryReport(error, stackTrace);
      await Sentry.captureException(
        report.throwable,
        stackTrace: report.stackTrace,
      );
      return;
    }
    await Sentry.captureException(error, stackTrace: stackTrace);
  }

  @override
  Future<void> logEvent({required String message}) async {
    try {
      await Sentry.captureEvent(
        SentryEvent(message: SentryMessage(message), level: SentryLevel.info),
      );
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }
}
