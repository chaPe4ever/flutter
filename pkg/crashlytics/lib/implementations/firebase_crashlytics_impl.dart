import 'dart:async';
import 'dart:isolate';

import 'package:crashlytics/crashlytics.dart';
import 'package:flutter/foundation.dart';

///
final class FirebaseCrashlyticsImpl implements CrashlyticsBase {
  ///
  FirebaseCrashlyticsImpl({
    required FirebaseCrashlytics crashlytics,
  }) : _crashlytics = crashlytics;

  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> log({required String message}) {
    try {
      return _crashlytics.log(message);
    } catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> setCrashlytics({required bool enabled}) async {
    try {
      return _crashlytics.setCrashlyticsCollectionEnabled(enabled);
    } catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> setUserId({required String userId}) {
    try {
      return _crashlytics.setUserIdentifier(userId);
    } catch (e, st) {
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
      Isolate.current.addErrorListener(
        RawReceivePort((List<dynamic> pair) async {
          final errorAndStacktrace = pair;
          await _crashlytics.recordError(
            errorAndStacktrace.first,
            StackTrace.fromString(errorAndStacktrace.last as String),
            fatal: true,
          );
        }).sendPort,
      );
    } catch (e, st) {
      throw UnknownCrashlyticsException(innerError: e, st: st);
    }
  }
}
