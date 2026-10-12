import 'package:core/core.dart';
import 'package:crashlytics/constants/crashlytics_constants.dart';
import 'package:crashlytics/exceptions/crashlytics_exceptions.dart';
import 'package:crashlytics/implementations/isolate_error_handlers.dart';
import 'package:crashlytics/implementations/sentry_bindings.dart';
import 'package:crashlytics/implementations/sentry_crashlytics_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../helpers/crashlytics_mocks.dart';
import '../helpers/sentry_test_binding.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('sentryReport', () {
    test('reports a core exception inner error with its stack', () {
      final inner = StateError('no space');
      final stack = StackTrace.current;
      final wrapped = UnknownCoreException(innerError: inner, st: stack);

      final report = sentryReport(wrapped, StackTrace.empty);

      expect(report.throwable, same(inner));
      expect(report.stackTrace, same(stack));
    });

    test('keeps the platform stack when the wrapper has none', () {
      final inner = StateError('no space');
      final stack = StackTrace.current;
      final wrapped = UnknownCoreException(innerError: inner);

      final report = sentryReport(wrapped, stack);

      expect(report.throwable, same(inner));
      expect(report.stackTrace, same(stack));
    });

    test('reports the original error when there is no inner error', () {
      final error = StateError('plain');
      final stack = StackTrace.current;

      final report = sentryReport(error, stack);

      expect(report.throwable, same(error));
      expect(report.stackTrace, same(stack));
    });

    test('reports a core exception that has only a message key', () {
      final wrapped = UnknownCoreException();
      final stack = StackTrace.current;

      final report = sentryReport(wrapped, stack);

      expect(report.throwable, same(wrapped));
      expect(report.stackTrace, same(stack));
    });
  });

  group('DefaultSentryCrashlyticsBindings', () {
    test('delegates captureEvent and bindClient to the Sentry SDK', () async {
      bindSentryTestClient();
      const bindings = DefaultSentryCrashlyticsBindings();

      await bindings.captureEvent(
        SentryEvent(message: SentryMessage('hello'), level: SentryLevel.info),
      );
      bindings.bindClient(SentryClient(SentryOptions(dsn: sentryDsn)));

      await Sentry.close();
    });
  });

  group('SentryCrashlyticsImpl', () {
    late MockSentryCrashlyticsBindings sentryBindings;
    late SentryCrashlyticsImpl impl;
    late FlutterExceptionHandler? originalFlutterErrorHandler;
    late bool Function(Object, StackTrace)? originalPlatformErrorHandler;

    setUpAll(registerCrashlyticsFallbacks);

    setUp(() {
      bindSentryTestClient();
      sentryBindings = MockSentryCrashlyticsBindings();
      when(
        () => sentryBindings.captureException(
          any<Object?>(),
          stackTrace: any(named: 'stackTrace'),
        ),
      ).thenAnswer((_) async => const SentryId.empty());
      when(() => sentryBindings.captureEvent(any())).thenAnswer((_) async {});
      when(() => sentryBindings.bindClient(any())).thenReturn(null);
      impl = SentryCrashlyticsImpl(sentry: sentryBindings);
      originalFlutterErrorHandler = FlutterError.onError;
      originalPlatformErrorHandler = PlatformDispatcher.instance.onError;
    });

    tearDown(() async {
      FlutterError.onError = originalFlutterErrorHandler;
      PlatformDispatcher.instance.onError = originalPlatformErrorHandler;
      await Sentry.close();
    });

    group('setCrashlytics', () {
      test('binds a no-op client when collection is disabled', () async {
        await expectLater(impl.setCrashlytics(enabled: false), completes);

        verify(() => sentryBindings.bindClient(any())).called(1);
      });

      test('does nothing when collection stays enabled', () async {
        await expectLater(impl.setCrashlytics(enabled: true), completes);

        verifyNever(() => sentryBindings.bindClient(any()));
      });

      test(
        'wraps unexpected failures in UnknownCrashlyticsException',
        () async {
          when(() => sentryBindings.bindClient(any())).thenThrow(
            Exception('fail'),
          );

          await expectLater(
            impl.setCrashlytics(enabled: false),
            throwsA(isA<UnknownCrashlyticsException>()),
          );
        },
      );
    });

    group('setUserId', () {
      test('completes without throwing', () async {
        await expectLater(impl.setUserId(userId: 'user-1'), completes);
      });

      test(
        'wraps unexpected failures in UnknownCrashlyticsException',
        () async {
          impl = SentryCrashlyticsImpl(
            sentry: sentryBindings,
            setUserIdAction: (_) async {
              throw Exception('fail');
            },
          );

          await expectLater(
            impl.setUserId(userId: 'user-1'),
            throwsA(isA<UnknownCrashlyticsException>()),
          );
        },
      );
    });

    group('captureException', () {
      test('unwraps core exceptions before sending to Sentry', () async {
        final inner = StateError('inner');
        final wrapped = UnknownCoreException(innerError: inner);

        await impl.captureException(wrapped, stackTrace: StackTrace.current);

        verify(
          () => sentryBindings.captureException(
            inner,
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(1);
      });

      test('forwards non-object errors directly to Sentry', () async {
        await impl.captureException(null, stackTrace: StackTrace.current);

        verify(
          () => sentryBindings.captureException(
            null,
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(1);
      });
    });

    group('logEvent', () {
      test('captures an info event in Sentry', () async {
        await expectLater(impl.logEvent(message: 'hello'), completes);

        verify(() => sentryBindings.captureEvent(any())).called(1);
      });

      test(
        'wraps unexpected failures in UnknownCrashlyticsException',
        () async {
          when(
            () => sentryBindings.captureEvent(any()),
          ).thenThrow(Exception('fail'));

          await expectLater(
            impl.logEvent(message: 'hello'),
            throwsA(isA<UnknownCrashlyticsException>()),
          );
        },
      );
    });

    group('testCrash', () {
      test('captures a test exception in debug mode', () {
        expect(() => impl.testCrash(), returnsNormally);

        verify(
          () => sentryBindings.captureException(
            any<Object?>(that: isA<UnknownCrashlyticsException>()),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(1);
      });
    });

    group('init', () {
      test(
        'captures Flutter framework errors and preserves prior handlers',
        () async {
          var previousCalled = false;
          FlutterError.onError = (_) {
            previousCalled = true;
          };

          await impl.init();

          final details = FlutterErrorDetails(
            exception: UnknownCoreException(
              innerError: StateError('framework'),
            ),
            stack: StackTrace.current,
          );
          FlutterError.onError!(details);

          expect(previousCalled, isTrue);
          verify(
            () => sentryBindings.captureException(
              any<Object?>(),
              stackTrace: any(named: 'stackTrace'),
            ),
          ).called(1);
        },
      );

      test(
        'captures uncaught async errors and preserves prior handlers',
        () async {
          var previousHandled = false;
          PlatformDispatcher.instance.onError = (_, stack) {
            previousHandled = true;
            return true;
          };

          await impl.init();

          final handled = PlatformDispatcher.instance.onError!(
            UnknownCoreException(innerError: StateError('async')),
            StackTrace.current,
          );

          expect(previousHandled, isTrue);
          expect(handled, isTrue);
        },
      );

      test('wraps init failures in UnknownCrashlyticsException', () async {
        impl = SentryCrashlyticsImpl(
          sentry: sentryBindings,
          registerIsolateErrorListener: throwingIsolateErrorListenerRegistrar(
            Exception('fail'),
          ),
        );

        await expectLater(
          impl.init(),
          throwsA(isA<UnknownCrashlyticsException>()),
        );
      });

      test('registers an isolate handler that reports to Sentry', () async {
        final captured = <void Function(List<dynamic> pair)>[];
        impl = SentryCrashlyticsImpl(
          sentry: sentryBindings,
          registerIsolateErrorListener: capturingIsolateErrorListener(
            captured,
          ),
        );

        await impl.init();

        captured.single([
          UnknownCoreException(innerError: StateError('isolate')),
          StackTrace.current.toString(),
        ]);

        verify(
          () => sentryBindings.captureException(
            any<Object?>(that: isA<StateError>()),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(1);
      });
    });

    group('onSentryIsolateError', () {
      test('unwraps object failures before sending them to Sentry', () {
        onSentryIsolateError(sentryBindings, [
          UnknownCoreException(innerError: StateError('isolate')),
          StackTrace.current.toString(),
        ]);

        verify(
          () => sentryBindings.captureException(
            any<Object?>(that: isA<StateError>()),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(1);
      });

      test('forwards non-object failures directly to Sentry', () {
        onSentryIsolateError(sentryBindings, [
          null,
          StackTrace.current.toString(),
        ]);

        verify(
          () => sentryBindings.captureException(
            null,
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(1);
      });
    });
  });
}
