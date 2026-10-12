import 'package:core/core.dart';
import 'package:crashlytics/implementations/sentry_bindings.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Chooses the throwable Sentry should title an issue with.
///
/// [CoreException] keeps the user-facing key on [CoreException.messageKey] and
/// the original failure on [CoreException.innerError]. Reporting the wrapper
/// makes the issue title that translation key.
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

/// Records a fatal isolate error on Firebase Crashlytics.
Future<void> onFirebaseIsolateError(
  FirebaseCrashlytics crashlytics,
  List<dynamic> pair,
) {
  return crashlytics.recordError(
    pair.first,
    StackTrace.fromString(pair.last as String),
    fatal: true,
  );
}

/// Reports an isolate error to Sentry.
void onSentryIsolateError(
  SentryCrashlyticsBindings sentry,
  List<dynamic> pair,
) {
  final error = pair.first;
  final stack = StackTrace.fromString(pair.last as String);
  if (error is Object) {
    final report = sentryReport(error, stack);
    sentry.captureException(
      report.throwable,
      stackTrace: report.stackTrace,
    );
  } else {
    sentry.captureException(error, stackTrace: stack);
  }
}

/// Records a fatal isolate error on Firebase for combined Sentry + Firebase
/// setup.
void onCombinedFirebaseIsolateError(
  FirebaseCrashlytics crashlytics,
  List<dynamic> pair,
) {
  crashlytics.recordError(
    pair.first,
    StackTrace.fromString(pair.last as String),
    fatal: true,
  );
}
