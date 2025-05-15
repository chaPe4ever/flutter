import 'dart:async';
import 'dart:isolate';

import 'package:crashlytics/crashlytics.dart';
import 'package:crashlytics/implementations/sentry_crashlytics_impl.dart';
import 'package:flutter/foundation.dart';

///
final class SentryAndFirebaseCrashlyticsImpl implements CrashlyticsBase {
  ///
  SentryAndFirebaseCrashlyticsImpl({
    required SentryCrashlyticsImpl sentryCrashlytics,
    required FirebaseCrashlyticsImpl firebaseCrashlytics,
  }) : _firebaseCrashlytics = firebaseCrashlytics,
       _sentryCrashlytics = sentryCrashlytics;

  final SentryCrashlyticsImpl _sentryCrashlytics;
  final FirebaseCrashlyticsImpl _firebaseCrashlytics;

  @override
  Future<void> logEvent({required String message}) async {
    try {
      await _sentryCrashlytics.logEvent(message: message);
      await _firebaseCrashlytics.logEvent(message: message);
    } catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> setCrashlytics({required bool enabled}) async {
    try {
      await _sentryCrashlytics.setCrashlytics(enabled: enabled);
      await _firebaseCrashlytics.setCrashlytics(enabled: enabled);
    } catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> setUserId({required String userId}) async {
    try {
      await _sentryCrashlytics.setUserId(userId: userId);
      await _firebaseCrashlytics.setUserId(userId: userId);
    } catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  void testCrash() {
    if (kDebugMode) {
      _sentryCrashlytics.testCrash();
      _firebaseCrashlytics.testCrash();
    }
  }

  @override
  Future<void> init() async {
    final fbCrashlytics = FirebaseCrashlytics.instance;
    try {
      // Capture whatever handler is there now (Sentry’s)
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        // Let Sentry handle it first
        originalOnError?.call(details);

        // Then send to Firebase Crashlytics
        fbCrashlytics.recordFlutterError(details);
      };

      // Same for uncaught async errors
      final originalPlatformHandler = PlatformDispatcher.instance.onError;
      PlatformDispatcher.instance.onError = (error, stack) {
        // Sentry’s handler is inside originalPlatformHandler
        final sentryHandled =
            originalPlatformHandler?.call(error, stack) ?? false;

        // Now Crashlytics
        fbCrashlytics.recordError(error, stack, fatal: true);

        return sentryHandled;
      };

      // And for isolates:
      Isolate.current.addErrorListener(
        RawReceivePort((List<dynamic> pair) {
          final error = pair.first;
          final stack = StackTrace.fromString(pair.last as String);

          // original handler—in Sentry’s zone—has already been wired to isolates,
          // so we just forward to Crashlytics here
          fbCrashlytics.recordError(error, stack, fatal: true);
        }).sendPort,
      );
    } catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> captureException(dynamic error, {StackTrace? stackTrace}) async {
    try {
      await _sentryCrashlytics.captureException(error, stackTrace: stackTrace);
      await _firebaseCrashlytics.captureException(
        error,
        stackTrace: stackTrace,
      );
    } catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }
}
