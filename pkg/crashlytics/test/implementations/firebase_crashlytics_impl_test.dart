import 'package:crashlytics/exceptions/crashlytics_exceptions.dart';
import 'package:crashlytics/implementations/firebase_crashlytics_impl.dart';
import 'package:crashlytics/implementations/isolate_error_handlers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/crashlytics_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FirebaseCrashlyticsImpl', () {
    late MockFirebaseCrashlytics firebaseCrashlytics;
    late FirebaseCrashlyticsImpl impl;
    late FlutterExceptionHandler? originalFlutterErrorHandler;
    late bool Function(Object, StackTrace)? originalPlatformErrorHandler;

    setUpAll(registerCrashlyticsFallbacks);

    setUp(() {
      firebaseCrashlytics = MockFirebaseCrashlytics();
      impl = FirebaseCrashlyticsImpl(crashlytics: firebaseCrashlytics);
      originalFlutterErrorHandler = FlutterError.onError;
      originalPlatformErrorHandler = PlatformDispatcher.instance.onError;
    });

    tearDown(() {
      FlutterError.onError = originalFlutterErrorHandler;
      PlatformDispatcher.instance.onError = originalPlatformErrorHandler;
    });

    group('setCrashlytics', () {
      test('forwards the enabled flag to Firebase Crashlytics', () async {
        when(
          () => firebaseCrashlytics.setCrashlyticsCollectionEnabled(any()),
        ).thenAnswer((_) async {});

        await impl.setCrashlytics(enabled: true);
        await impl.setCrashlytics(enabled: false);

        verify(
          () => firebaseCrashlytics.setCrashlyticsCollectionEnabled(true),
        ).called(1);
        verify(
          () => firebaseCrashlytics.setCrashlyticsCollectionEnabled(false),
        ).called(1);
      });

      test('wraps delegate failures in UnknownCrashlyticsException', () async {
        when(
          () => firebaseCrashlytics.setCrashlyticsCollectionEnabled(any()),
        ).thenThrow(Exception('channel down'));

        await expectLater(
          impl.setCrashlytics(enabled: true),
          throwsA(isA<UnknownCrashlyticsException>()),
        );
      });
    });

    group('setUserId', () {
      test('forwards the user id to Firebase Crashlytics', () async {
        when(
          () => firebaseCrashlytics.setUserIdentifier(any()),
        ).thenAnswer((_) async {});

        await impl.setUserId(userId: 'user-42');

        verify(
          () => firebaseCrashlytics.setUserIdentifier('user-42'),
        ).called(1);
      });

      test('wraps delegate failures in UnknownCrashlyticsException', () async {
        when(
          () => firebaseCrashlytics.setUserIdentifier(any()),
        ).thenThrow(Exception('channel down'));

        expect(
          () => impl.setUserId(userId: 'user-42'),
          throwsA(isA<UnknownCrashlyticsException>()),
        );
      });
    });

    group('captureException', () {
      test('records fatal errors on the delegate', () async {
        final error = StateError('boom');
        final stack = StackTrace.current;
        when(
          () => firebaseCrashlytics.recordError(
            any<Object>(),
            any<StackTrace?>(),
            fatal: any(named: 'fatal'),
          ),
        ).thenAnswer((_) async {});

        await impl.captureException(error, stackTrace: stack);

        verify(
          () => firebaseCrashlytics.recordError(error, stack, fatal: true),
        ).called(1);
      });

      test('wraps delegate failures in UnknownCrashlyticsException', () async {
        when(
          () => firebaseCrashlytics.recordError(
            any<Object>(),
            any<StackTrace?>(),
            fatal: any(named: 'fatal'),
          ),
        ).thenThrow(Exception('channel down'));

        expect(
          () => impl.captureException(StateError('boom')),
          throwsA(isA<UnknownCrashlyticsException>()),
        );
      });
    });

    group('logEvent', () {
      test('forwards log messages to Firebase Crashlytics', () async {
        when(() => firebaseCrashlytics.log(any())).thenAnswer((_) async {});

        await impl.logEvent(message: 'hello');

        verify(() => firebaseCrashlytics.log('hello')).called(1);
      });

      test('wraps delegate failures in UnknownCrashlyticsException', () async {
        when(
          () => firebaseCrashlytics.log(any()),
        ).thenThrow(Exception('channel down'));

        expect(
          () => impl.logEvent(message: 'hello'),
          throwsA(isA<UnknownCrashlyticsException>()),
        );
      });
    });

    group('testCrash', () {
      test('requests a native crash in debug mode', () {
        when(() => firebaseCrashlytics.crash()).thenReturn(null);

        impl.testCrash();

        verify(() => firebaseCrashlytics.crash()).called(1);
      });
    });

    group('init', () {
      test('routes Flutter framework errors to Firebase Crashlytics', () async {
        when(
          () => firebaseCrashlytics.recordFlutterError(any()),
        ).thenAnswer((_) async {});

        await impl.init();

        final details = FlutterErrorDetails(
          exception: StateError('framework'),
          stack: StackTrace.current,
        );
        FlutterError.onError!(details);

        verify(() => firebaseCrashlytics.recordFlutterError(details)).called(1);
      });

      test('routes uncaught async errors to Firebase Crashlytics', () async {
        when(
          () => firebaseCrashlytics.recordError(
            any<Object>(),
            any<StackTrace?>(),
            fatal: any(named: 'fatal'),
          ),
        ).thenAnswer((_) async {});

        await impl.init();

        final error = StateError('async');
        final stack = StackTrace.current;
        final handled = PlatformDispatcher.instance.onError!(error, stack);

        expect(handled, isTrue);
        verify(
          () => firebaseCrashlytics.recordError(error, stack, fatal: true),
        ).called(1);
      });

      test('wraps init failures in UnknownCrashlyticsException', () async {
        impl = FirebaseCrashlyticsImpl(
          crashlytics: firebaseCrashlytics,
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
        impl = FirebaseCrashlyticsImpl(
          crashlytics: firebaseCrashlytics,
          registerIsolateErrorListener: capturingIsolateErrorListener(captured),
        );
        final error = StateError('isolate');
        final stack = StackTrace.current.toString();
        when(
          () => firebaseCrashlytics.recordError(
            any<Object>(),
            any<StackTrace?>(),
            fatal: any(named: 'fatal'),
          ),
        ).thenAnswer((_) async {});

        await impl.init();

        expect(captured, hasLength(1));
        captured.first([error, stack]);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => firebaseCrashlytics.recordError(
            error,
            any<StackTrace>(that: isA<StackTrace>()),
            fatal: true,
          ),
        ).called(1);
      });
    });

    group('onFirebaseIsolateError', () {
      test('records fatal isolate errors on the delegate', () async {
        final error = StateError('isolate');
        final stack = StackTrace.current.toString();
        when(
          () => firebaseCrashlytics.recordError(
            any<Object>(),
            any<StackTrace?>(),
            fatal: any(named: 'fatal'),
          ),
        ).thenAnswer((_) async {});

        await onFirebaseIsolateError(firebaseCrashlytics, [error, stack]);

        verify(
          () => firebaseCrashlytics.recordError(
            error,
            any<StackTrace>(that: isA<StackTrace>()),
            fatal: true,
          ),
        ).called(1);
      });
    });
  });
}
