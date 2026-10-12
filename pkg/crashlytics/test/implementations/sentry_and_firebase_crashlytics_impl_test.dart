import 'package:crashlytics/exceptions/crashlytics_exceptions.dart';
import 'package:crashlytics/implementations/firebase_crashlytics_impl.dart';
import 'package:crashlytics/implementations/isolate_error_handlers.dart';
import 'package:crashlytics/implementations/sentry_and_firebase_crashlytics_impl.dart';
import 'package:crashlytics/implementations/sentry_crashlytics_impl.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../helpers/crashlytics_mocks.dart';
import '../helpers/firebase_crashlytics_test_setup.dart';
import '../helpers/sentry_test_binding.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SentryAndFirebaseCrashlyticsImpl', () {
    late MockFirebaseCrashlytics mockFirebaseCrashlytics;
    late FirebaseCrashlyticsImpl firebaseImpl;
    late SentryCrashlyticsImpl sentryImpl;
    late SentryAndFirebaseCrashlyticsImpl impl;
    late FlutterExceptionHandler? originalFlutterErrorHandler;
    late bool Function(Object, StackTrace)? originalPlatformErrorHandler;

    setUpAll(() async {
      registerCrashlyticsFallbacks();
      await ensureDefaultFirebaseApp();
    });

    setUp(() {
      fakeFirebaseCrashlyticsHostApi.reset();
      bindSentryTestClient();
      mockFirebaseCrashlytics = MockFirebaseCrashlytics();
      firebaseImpl = FirebaseCrashlyticsImpl(
        crashlytics: mockFirebaseCrashlytics,
      );
      sentryImpl = SentryCrashlyticsImpl();
      impl = SentryAndFirebaseCrashlyticsImpl(
        sentryCrashlytics: sentryImpl,
        firebaseCrashlytics: firebaseImpl,
      );
      originalFlutterErrorHandler = FlutterError.onError;
      originalPlatformErrorHandler = PlatformDispatcher.instance.onError;
    });

    tearDown(() async {
      FlutterError.onError = originalFlutterErrorHandler;
      PlatformDispatcher.instance.onError = originalPlatformErrorHandler;
      await Sentry.close();
    });

    group('logEvent', () {
      test('forwards messages to Firebase and Sentry', () async {
        when(() => mockFirebaseCrashlytics.log(any())).thenAnswer((_) async {});

        await impl.logEvent(message: 'hello');

        verify(() => mockFirebaseCrashlytics.log('hello')).called(1);
      });

      test('wraps delegate failures in UnknownCrashlyticsException', () async {
        when(
          () => mockFirebaseCrashlytics.log(any()),
        ).thenThrow(Exception('channel down'));

        await expectLater(
          impl.logEvent(message: 'hello'),
          throwsA(isA<UnknownCrashlyticsException>()),
        );
      });
    });

    group('setCrashlytics', () {
      test('updates both backends', () async {
        when(
          () => mockFirebaseCrashlytics.setCrashlyticsCollectionEnabled(any()),
        ).thenAnswer((_) async {});

        await impl.setCrashlytics(enabled: true);

        verify(
          () => mockFirebaseCrashlytics.setCrashlyticsCollectionEnabled(true),
        ).called(1);
      });

      test('wraps delegate failures in UnknownCrashlyticsException', () async {
        when(
          () => mockFirebaseCrashlytics.setCrashlyticsCollectionEnabled(any()),
        ).thenThrow(Exception('channel down'));

        await expectLater(
          impl.setCrashlytics(enabled: true),
          throwsA(isA<UnknownCrashlyticsException>()),
        );
      });
    });

    group('setUserId', () {
      test('forwards the user id to Firebase', () async {
        when(
          () => mockFirebaseCrashlytics.setUserIdentifier(any()),
        ).thenAnswer((_) async {});

        await impl.setUserId(userId: 'user-42');

        verify(
          () => mockFirebaseCrashlytics.setUserIdentifier('user-42'),
        ).called(1);
      });

      test('wraps delegate failures in UnknownCrashlyticsException', () async {
        when(
          () => mockFirebaseCrashlytics.setUserIdentifier(any()),
        ).thenThrow(Exception('channel down'));

        await expectLater(
          impl.setUserId(userId: 'user-42'),
          throwsA(isA<UnknownCrashlyticsException>()),
        );
      });
    });

    group('captureException', () {
      test('records on Firebase after Sentry', () async {
        when(
          () => mockFirebaseCrashlytics.recordError(
            any<Object>(),
            any<StackTrace?>(),
            fatal: any(named: 'fatal'),
          ),
        ).thenAnswer((_) async {});

        await impl.captureException(
          StateError('boom'),
          stackTrace: StackTrace.current,
        );

        verify(
          () => mockFirebaseCrashlytics.recordError(
            any<Object>(that: isA<StateError>()),
            any<StackTrace>(that: isA<StackTrace>()),
            fatal: true,
          ),
        ).called(1);
      });

      test('wraps delegate failures in UnknownCrashlyticsException', () async {
        when(
          () => mockFirebaseCrashlytics.recordError(
            any<Object>(),
            any<StackTrace?>(),
            fatal: any(named: 'fatal'),
          ),
        ).thenThrow(Exception('channel down'));

        await expectLater(
          impl.captureException(StateError('boom')),
          throwsA(isA<UnknownCrashlyticsException>()),
        );
      });
    });

    group('testCrash', () {
      test('delegates to both backends in debug mode', () {
        when(() => mockFirebaseCrashlytics.crash()).thenReturn(null);

        impl.testCrash();

        verify(() => mockFirebaseCrashlytics.crash()).called(1);
      });
    });

    group('init', () {
      test('chains Flutter errors through the previous handler', () async {
        var previousCalled = false;
        FlutterError.onError = (_) {
          previousCalled = true;
        };

        await impl.init();

        final details = FlutterErrorDetails(
          exception: StateError('framework'),
          stack: StackTrace.current,
        );
        FlutterError.onError!(details);

        expect(previousCalled, isTrue);
        expect(fakeFirebaseCrashlyticsHostApi.calls, contains('recordError'));
      });

      test('forwards uncaught async errors after the prior handler', () async {
        const previousHandled = true;
        PlatformDispatcher.instance.onError = (_, stack) => previousHandled;

        await impl.init();

        final handled = PlatformDispatcher.instance.onError!(
          StateError('async'),
          StackTrace.current,
        );

        expect(handled, isTrue);
      });

      test('wraps init failures in UnknownCrashlyticsException', () async {
        impl = SentryAndFirebaseCrashlyticsImpl(
          sentryCrashlytics: sentryImpl,
          firebaseCrashlytics: firebaseImpl,
          registerIsolateErrorListener: throwingIsolateErrorListenerRegistrar(
            Exception('fail'),
          ),
        );

        await expectLater(
          impl.init(),
          throwsA(isA<UnknownCrashlyticsException>()),
        );
      });

      test('registers an isolate handler that records errors', () async {
        final captured = <void Function(List<dynamic> pair)>[];
        impl = SentryAndFirebaseCrashlyticsImpl(
          sentryCrashlytics: sentryImpl,
          firebaseCrashlytics: firebaseImpl,
          registerIsolateErrorListener: capturingIsolateErrorListener(captured),
        );

        await impl.init();
        captured.single([
          StateError('isolate'),
          StackTrace.current.toString(),
        ]);

        expect(fakeFirebaseCrashlyticsHostApi.calls, contains('recordError'));
      });
    });

    group('onCombinedFirebaseIsolateError', () {
      test('records fatal isolate errors on Firebase Crashlytics', () {
        onCombinedFirebaseIsolateError(
          FirebaseCrashlytics.instance,
          [StateError('isolate'), StackTrace.current.toString()],
        );

        expect(fakeFirebaseCrashlyticsHostApi.calls, contains('recordError'));
      });
    });
  });
}
