import 'dart:async';

import 'package:core/core.dart' show CoreException;

///
abstract interface class CrashlyticsBase {
  /// Might throw [CoreException]
  Future<void> setCrashlytics({required bool enabled});

  ///
  void testCrash();

  /// Might throw [CoreException]
  Future<void> logEvent({required String message});

  Future<void> captureException(dynamic error, {StackTrace? stackTrace});

  /// Might throw [CoreException]
  Future<void> setUserId({required String userId});

  /// Might throw [CoreException]
  Future<void> init();
}
