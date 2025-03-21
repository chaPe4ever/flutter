import 'dart:developer';

import 'package:core/contracts/core_exception.dart';
import 'package:core/pods/logger_pod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class LoggerHelper {
  const LoggerHelper._();

  /// It logs the coreException message providing the error itself to stacktrace
  /// if [customErrorToLog] is provided, it provides that error to stacktrace
  /// instead
  static Never logAndThrow<T>({
    required CoreException e,
    required WidgetRef ref,
    dynamic customErrorToLog,
    StackTrace? st,
  }) {
    ref.read(loggerPod).e(e.messageKey, e: customErrorToLog ?? e, st: st);

    throw e;
  }

  /// It logs the coreException error to crashlytics if [ref] is passed else
  /// only to console
  static void logError({
    required CoreException e,
    WidgetRef? ref,
    StackTrace? st,
  }) {
    if (ref != null) {
      ref.read(loggerPod).e(e.messageKey, e: e, st: st);
    } else {
      log(
        e.messageKey,
        level: 1000,
        name: e.runtimeType.toString(),
        error: e,
        stackTrace: st,
      );
    }
  }
}
