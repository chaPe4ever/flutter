import 'package:crashlytics/crashlytics.dart';
import 'package:crashlytics/implementations/isolate_error_handlers.dart';
import 'package:crashlytics/implementations/isolate_error_listener.dart';
import 'package:flutter/foundation.dart';

///
final class FirebaseCrashlyticsImpl implements CrashlyticsBase {
  ///
  FirebaseCrashlyticsImpl({
    required FirebaseCrashlytics crashlytics,
    IsolateErrorListenerRegistrar? registerIsolateErrorListener,
  }) : _crashlytics = crashlytics,
       _registerIsolateErrorListener =
           registerIsolateErrorListener ?? registerDefaultIsolateErrorListener;

  final FirebaseCrashlytics _crashlytics;
  final IsolateErrorListenerRegistrar _registerIsolateErrorListener;

  @override
  Future<void> setCrashlytics({required bool enabled}) async {
    try {
      return await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> setUserId({required String userId}) {
    try {
      return _crashlytics.setUserIdentifier(userId);
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  void testCrash() {
    if (kDebugMode) {
      _crashlytics.crash();
    }
  }

  @override
  Future<void> init() async {
    try {
      // Catch all errors that are thrown within the Flutter framework
      FlutterError.onError = _crashlytics.recordFlutterError;

      // Pass all uncaught asynchronous errors that aren't handled by the
      // Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };

      // Catch errors that happen outside of the Flutter context
      _registerIsolateErrorListener((pair) {
        onFirebaseIsolateError(_crashlytics, pair);
      });
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> captureException(dynamic error, {StackTrace? stackTrace}) {
    try {
      return _crashlytics.recordError(error, stackTrace, fatal: true);
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> logEvent({required String message}) {
    try {
      return _crashlytics.log(message);
    } on Exception catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }
}
