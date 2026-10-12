import 'package:crashlytics/crashlytics.dart';
import 'package:crashlytics/implementations/isolate_error_handlers.dart';
import 'package:crashlytics/implementations/isolate_error_listener.dart';
import 'package:crashlytics/implementations/sentry_bindings.dart';
import 'package:flutter/foundation.dart';

///
final class SentryCrashlyticsImpl implements CrashlyticsBase {
  ///
  SentryCrashlyticsImpl({
    SentryCrashlyticsBindings? sentry,
    IsolateErrorListenerRegistrar? registerIsolateErrorListener,
    SentryUserIdSetter? setUserIdAction,
  }) : _sentry = sentry ?? const DefaultSentryCrashlyticsBindings(),
       _registerIsolateErrorListener =
           registerIsolateErrorListener ?? registerDefaultIsolateErrorListener,
       _setUserIdAction = setUserIdAction ?? defaultSentryUserIdSetter;

  final SentryCrashlyticsBindings _sentry;
  final IsolateErrorListenerRegistrar _registerIsolateErrorListener;
  final SentryUserIdSetter _setUserIdAction;

  @override
  Future<void> setCrashlytics({required bool enabled}) async {
    try {
      if (!enabled) {
        _sentry.bindClient(disabledSentryClient());
      }
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> setUserId({required String userId}) async {
    try {
      await _setUserIdAction(userId);
      // TODOCheck if this is the right way to set user id in Sentry
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  void testCrash() {
    if (kDebugMode) {
      _sentry.captureException(
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
        _sentry.captureException(
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
        _sentry.captureException(
          report.throwable,
          stackTrace: report.stackTrace,
        );
        // call original (if any) so nothing else breaks
        return originalPlatformHandler?.call(error, stack) ?? false;
      };

      //And in spawned isolates:
      _registerIsolateErrorListener((pair) {
        onSentryIsolateError(_sentry, pair);
      });
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
      await _sentry.captureException(
        report.throwable,
        stackTrace: report.stackTrace,
      );
      return;
    }
    await _sentry.captureException(error, stackTrace: stackTrace);
  }

  @override
  Future<void> logEvent({required String message}) async {
    try {
      await _sentry.captureEvent(
        SentryEvent(message: SentryMessage(message), level: SentryLevel.info),
      );
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }
}
