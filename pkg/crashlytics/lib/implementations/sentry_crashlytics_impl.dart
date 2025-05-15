import 'dart:async';
import 'dart:isolate';

import 'package:crashlytics/crashlytics.dart';
import 'package:flutter/foundation.dart';

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
    } catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> setUserId({required String userId}) async {
    try {
      // TODO: Check if this is the right way to set user id in Sentry
    } catch (e, st) {
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
        Sentry.captureException(details.exception, stackTrace: details.stack);

        // Then call any previous handler
        originalOnError?.call(details);
      };

      // Same for uncaught async errors
      final originalPlatformHandler = PlatformDispatcher.instance.onError;

      PlatformDispatcher.instance.onError = (error, stack) {
        Sentry.captureException(error, stackTrace: stack);
        // call original (if any) so nothing else breaks
        return originalPlatformHandler?.call(error, stack) ?? false;
      };

      //And in spawned isolates:
      Isolate.current.addErrorListener(
        RawReceivePort((List<dynamic> pair) {
          final error = pair.first;
          final stack = StackTrace.fromString(pair.last as String);
          Sentry.captureException(error, stackTrace: stack);
        }).sendPort,
      );
    } catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> captureException(dynamic error, {StackTrace? stackTrace}) async {
    await Sentry.captureException(error, stackTrace: stackTrace);
  }

  @override
  Future<void> logEvent({required String message}) async {
    try {
      await Sentry.captureEvent(
        SentryEvent(message: SentryMessage(message), level: SentryLevel.info),
      );
    } catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }
}
