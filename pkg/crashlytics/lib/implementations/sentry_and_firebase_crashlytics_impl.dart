import 'package:crashlytics/crashlytics.dart';
import 'package:crashlytics/implementations/isolate_error_handlers.dart';
import 'package:crashlytics/implementations/isolate_error_listener.dart';
import 'package:crashlytics/implementations/sentry_crashlytics_impl.dart';
import 'package:flutter/foundation.dart';

///
final class SentryAndFirebaseCrashlyticsImpl implements CrashlyticsBase {
  ///
  SentryAndFirebaseCrashlyticsImpl({
    required SentryCrashlyticsImpl sentryCrashlytics,
    required FirebaseCrashlyticsImpl firebaseCrashlytics,
    FirebaseCrashlytics? firebaseCrashlyticsInstance,
    IsolateErrorListenerRegistrar? registerIsolateErrorListener,
  }) : _firebaseCrashlytics = firebaseCrashlytics,
       _sentryCrashlytics = sentryCrashlytics,
       _firebaseCrashlyticsInstance =
           firebaseCrashlyticsInstance ?? FirebaseCrashlytics.instance,
       _registerIsolateErrorListener =
           registerIsolateErrorListener ?? registerDefaultIsolateErrorListener;

  final SentryCrashlyticsImpl _sentryCrashlytics;
  final FirebaseCrashlyticsImpl _firebaseCrashlytics;
  final FirebaseCrashlytics _firebaseCrashlyticsInstance;
  final IsolateErrorListenerRegistrar _registerIsolateErrorListener;

  @override
  Future<void> logEvent({required String message}) async {
    try {
      await _sentryCrashlytics.logEvent(message: message);
      await _firebaseCrashlytics.logEvent(message: message);
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> setCrashlytics({required bool enabled}) async {
    try {
      await _sentryCrashlytics.setCrashlytics(enabled: enabled);
      await _firebaseCrashlytics.setCrashlytics(enabled: enabled);
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> setUserId({required String userId}) async {
    try {
      await _sentryCrashlytics.setUserId(userId: userId);
      await _firebaseCrashlytics.setUserId(userId: userId);
    } on Exception catch (e, st) {
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
    try {
      // Capture whatever handler is there now (Sentry’s)
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        // Let Sentry handle it first
        originalOnError?.call(details);

        // Then send to Firebase Crashlytics
        _firebaseCrashlyticsInstance.recordFlutterError(details);
      };

      // Same for uncaught async errors
      final originalPlatformHandler = PlatformDispatcher.instance.onError;
      PlatformDispatcher.instance.onError = (error, stack) {
        // Sentry’s handler is inside originalPlatformHandler
        final sentryHandled =
            originalPlatformHandler?.call(error, stack) ?? false;

        // Now Crashlytics
        _firebaseCrashlyticsInstance.recordError(error, stack, fatal: true);

        return sentryHandled;
      };

      // And for isolates:
      _registerIsolateErrorListener((pair) {
        onCombinedFirebaseIsolateError(_firebaseCrashlyticsInstance, pair);
      });
    } on Exception catch (e, st) {
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
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }
}
