import 'package:crashlytics/constants/crashlytics_constants.dart';
import 'package:crashlytics/implementations/isolate_error_listener.dart';
import 'package:crashlytics/implementations/sentry_bindings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'firebase_crashlytics_test_setup.dart';

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

class MockSentryCrashlyticsBindings extends Mock
    implements SentryCrashlyticsBindings {}

const kTestFirebaseOptions = FirebaseOptions(
  apiKey: 'api-key',
  appId: '1:1:web:abc',
  messagingSenderId: '1',
  projectId: 'project-id',
);

void registerCrashlyticsFallbacks() {
  registerFallbackValue('');
  registerFallbackValue(false);
  registerFallbackValue(
    FlutterErrorDetails(exception: Exception('fallback')),
  );
  registerFallbackValue(StackTrace.empty);
  registerFallbackValue(SentryEvent(message: SentryMessage('fallback')));
  registerFallbackValue(SentryClient(SentryOptions(dsn: sentryDsn)));
}

/// Captures isolate error handlers passed to the registrar callback.
IsolateErrorListenerRegistrar capturingIsolateErrorListener(
  List<void Function(List<dynamic> pair)> captured,
) {
  return (handler) {
    captured.add(handler);
  };
}

/// Throws when registering so initialization catch blocks can be tested.
IsolateErrorListenerRegistrar throwingIsolateErrorListenerRegistrar(
  Exception exception,
) {
  return (_) {
    throw exception;
  };
}

Future<void> ensureDefaultFirebaseApp() async {
  setupFirebaseCrashlyticsPlatformMocks();
  try {
    await Firebase.initializeApp(options: kTestFirebaseOptions);
  } on FirebaseException catch (error) {
    if (error.code != 'duplicate-app') {
      rethrow;
    }
  }
}
