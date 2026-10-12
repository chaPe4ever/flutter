import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLogger implements LoggerBase {
  final List<String> errors = [];

  @override
  void d(String message, {dynamic e, StackTrace? st}) {}

  @override
  void e(String message, {dynamic e, StackTrace? st}) {
    errors.add(message);
  }

  @override
  void i(String message, {dynamic e, StackTrace? st}) {}

  @override
  void t(String message, {dynamic e, StackTrace? st}) {}

  @override
  void w(String message, {dynamic e, StackTrace? st}) {}
}

class _FakeNetwork implements NetworkBase {
  _FakeNetwork({this.connected = true});

  final bool connected;

  @override
  Future<bool> get isConnected async => connected;

  @override
  Stream<NetworkStatus> get connectionStatusStream => const Stream.empty();

  @override
  void dispose() {}

  @override
  void addListener({VoidCallback? onOnline, VoidCallback? onOffline}) {}

  @override
  void removeListener({VoidCallback? onOnline, VoidCallback? onOffline}) {}
}

void main() {
  tearDown(FunctionsAuthFailureHandler.reset);

  group('firestoreFutureTryCatch', () {
    test('maps FirebaseException to FirestoreException', () async {
      final logger = _FakeLogger();
      await expectLater(
        () => firestoreFutureTryCatch<void>(
          () async {
            throw FirebaseException(
              plugin: 'firestore',
              code: 'permission-denied',
              message: 'denied',
            );
          },
          logger: logger,
        ),
        throwsA(isA<FirestoreException>()),
      );
      expect(logger.errors, isNotEmpty);
    });

    test('rethrows CoreException', () async {
      final logger = _FakeLogger();
      const ex = NoNetworkException();
      await expectLater(
        () => firestoreFutureTryCatch<void>(
          () async => throw ex,
          logger: logger,
        ),
        throwsA(same(ex)),
      );
    });

    test('maps DioException to DioClientException', () async {
      final logger = _FakeLogger();
      await expectLater(
        () => firestoreFutureTryCatch<void>(
          () async {
            throw DioException(
              requestOptions: RequestOptions(path: '/'),
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: RequestOptions(path: '/'),
                statusCode: 500,
                statusMessage: 'error',
              ),
            );
          },
          logger: logger,
        ),
        throwsA(isA<DioClientException>()),
      );
    });

    test('wraps unknown errors', () async {
      final logger = _FakeLogger();
      await expectLater(
        () => firestoreFutureTryCatch<void>(
          () async => throw StateError('boom'),
          logger: logger,
        ),
        throwsA(isA<UnknownCoreException>()),
      );
    });
  });

  group('firestoreStreamTryCatch', () {
    test('maps stream errors to FirestoreException', () async {
      final logger = _FakeLogger();
      final stream = firestoreStreamTryCatch<int>(
        () => Stream<int>.error(
          FirebaseException(
            plugin: 'firestore',
            code: 'unavailable',
            message: 'down',
          ),
        ),
        logger: logger,
      );

      await expectLater(stream, emitsError(isA<FirestoreException>()));
    });

    test('rethrows CoreException from stream', () async {
      final logger = _FakeLogger();
      const ex = NoNetworkException();
      final stream = firestoreStreamTryCatch<int>(
        () => Stream<int>.error(ex, StackTrace.current),
        logger: logger,
      );

      await expectLater(stream, emitsError(same(ex)));
    });

    test('wraps unknown stream errors', () async {
      final logger = _FakeLogger();
      final stream = firestoreStreamTryCatch<int>(
        () => Stream<int>.error(StateError('boom'), StackTrace.empty),
        logger: logger,
      );

      await expectLater(stream, emitsError(isA<UnknownCoreException>()));
    });
  });

  group('functionsFutureTryCatch', () {
    test('uses custom callback instead of throwing', () async {
      final logger = _FakeLogger();
      final result = await functionsFutureTryCatch<int>(
        () async => throw FirebaseFunctionsException(
          code: 'internal',
          message: 'fail',
        ),
        logger: logger,
        onFunctionsCustomExCb: (_, _) => 99,
      );
      expect(result, 99);
    });

    test('rethrows CoreException', () async {
      final logger = _FakeLogger();
      const ex = NoNetworkException();
      await expectLater(
        () => functionsFutureTryCatch<void>(
          () async => throw ex,
          logger: logger,
        ),
        throwsA(same(ex)),
      );
    });

    test('wraps unknown errors as UnknownCoreException', () async {
      final logger = _FakeLogger();
      await expectLater(
        () => functionsFutureTryCatch<void>(
          () async => throw StateError('boom'),
          logger: logger,
        ),
        throwsA(isA<UnknownCoreException>()),
      );
    });
  });

  group('futureEitherTryCatch', () {
    test('returns Left when offline', () async {
      final result = await futureEitherTryCatch<int>(
        () async => 1,
        network: _FakeNetwork(connected: false),
      );
      expect(result, isA<Left<CoreException, int>>());
    });

    test('returns Right when online', () async {
      final result = await futureEitherTryCatch<int>(
        () async => 7,
        network: _FakeNetwork(),
      );
      expect(result, right<CoreException, int>(7));
    });

    test('returns Left for thrown errors', () async {
      final result = await futureEitherTryCatch<int>(
        () async => throw StateError('x'),
        network: _FakeNetwork(),
      );
      expect(result.isLeft(), isTrue);
    });

    test('returns Left with same CoreException', () async {
      const ex = NoNetworkException();
      final result = await futureEitherTryCatch<int>(
        () async => throw ex,
        network: _FakeNetwork(),
      );
      expect(result, left<CoreException, int>(ex));
    });

    test('uses cache when cacheDuration is at least one second', () async {
      var calls = 0;
      final result = await futureEitherTryCatch<int>(
        () async {
          calls++;
          return 3;
        },
        network: _FakeNetwork(),
        cacheDuration: const Duration(seconds: 2),
      );

      expect(result, right<CoreException, int>(3));
      expect(calls, 1);
    });
  });

  group('futureOptionTryCatch', () {
    test('returns Some when offline', () async {
      final result = await futureOptionTryCatch(
        () async {},
        network: _FakeNetwork(connected: false),
      );
      expect(result, isA<Some<CoreException>>());
    });

    test('returns None when online and succeeds', () async {
      final result = await futureOptionTryCatch(
        () async {},
        network: _FakeNetwork(),
      );
      expect(result, none<CoreException>());
    });

    test('returns Some when online and callback throws', () async {
      final result = await futureOptionTryCatch(
        () async => throw StateError('x'),
        network: _FakeNetwork(),
      );
      expect(result, isA<Some<CoreException>>());
    });
  });

  group('streamEitherTryCatch', () {
    test('yields Left when offline', () async {
      final stream = streamEitherTryCatch<int>(
        () => Stream.value(1),
        network: _FakeNetwork(connected: false),
      );
      await expectLater(stream, emits(isA<Left<CoreException, int>>()));
    });

    test('yields Right values when online', () async {
      final stream = streamEitherTryCatch<int>(
        () => Stream.fromIterable([1, 2]),
        network: _FakeNetwork(),
      );
      await expectLater(
        stream,
        emitsInOrder([
          right<CoreException, int>(1),
          right<CoreException, int>(2),
        ]),
      );
    });
  });

  group('dioTryCatch', () {
    test('maps DioException to DioClientException', () async {
      final logger = _FakeLogger();
      final dio = Dio();
      await expectLater(
        () => dioTryCatch<void>(
          () async {
            throw DioException(
              requestOptions: RequestOptions(path: '/'),
              type: DioExceptionType.connectionTimeout,
            );
          },
          logger: logger,
          dio: dio,
        ),
        throwsA(isA<DioClientException>()),
      );
    });

    test('rethrows CoreException', () async {
      final logger = _FakeLogger();
      const ex = NoNetworkException();
      final dio = Dio();
      await expectLater(
        () => dioTryCatch<void>(
          () async => throw ex,
          logger: logger,
          dio: dio,
        ),
        throwsA(same(ex)),
      );
    });

    test('wraps unknown errors as UnknownCoreException', () async {
      final logger = _FakeLogger();
      final dio = Dio();
      await expectLater(
        () => dioTryCatch<void>(
          () async => throw StateError('boom'),
          logger: logger,
          dio: dio,
        ),
        throwsA(isA<UnknownCoreException>()),
      );
    });
  });

  group('futureTryCatch', () {
    test('throws NoNetworkException when offline and not fake mode', () async {
      AppModeHelper().setMode(AppModeEnum.real);
      addTearDown(AppModeHelper().reset);

      await expectLater(
        () => futureTryCatch<int>(
          () async => 1,
          network: _FakeNetwork(connected: false),
        ),
        throwsA(isA<NoNetworkException>()),
      );
    });

    test('runs when fake mode even if offline', () async {
      AppModeHelper().setMode(AppModeEnum.fake);
      addTearDown(AppModeHelper().reset);

      final value = await futureTryCatch<int>(
        () async => 5,
        network: _FakeNetwork(connected: false),
      );
      expect(value, 5);
    });

    test('uses cache when cacheDuration is at least one second', () async {
      var calls = 0;
      final value = await futureTryCatch<int>(
        () async {
          calls++;
          return 9;
        },
        network: _FakeNetwork(),
        cacheDuration: const Duration(seconds: 1),
      );
      expect(value, 9);
      expect(calls, 1);
    });

    test('wraps unknown errors as UnknownCoreException', () async {
      await expectLater(
        () => futureTryCatch<int>(
          () async => throw StateError('x'),
          network: _FakeNetwork(),
        ),
        throwsA(isA<UnknownCoreException>()),
      );
    });
  });

  group('streamTryCatch', () {
    test('yields values when online', () async {
      final stream = streamTryCatch<int>(
        () => Stream.fromIterable([1, 2]),
        network: _FakeNetwork(),
      );
      await expectLater(stream, emitsInOrder([1, 2]));
    });

    test('throws NoNetworkException when offline', () async {
      final stream = streamTryCatch<int>(
        () => Stream.value(1),
        network: _FakeNetwork(connected: false),
      );
      await expectLater(stream, emitsError(isA<NoNetworkException>()));
    });

    test('wraps stream errors as CoreException when online', () async {
      final stream = streamTryCatch<int>(
        () => Stream<int>.error(StateError('x'), StackTrace.current),
        network: _FakeNetwork(),
      );
      await expectLater(stream, emitsError(isA<CoreException>()));
    });
  });

  group('futureTryCatch CoreException', () {
    test('rethrows CoreException from callback', () async {
      const ex = NoNetworkException();
      await expectLater(
        () => futureTryCatch<void>(
          () async => throw ex,
          network: _FakeNetwork(),
        ),
        throwsA(same(ex)),
      );
    });
  });

  group('streamEitherTryCatch errors', () {
    test('propagates stream errors when online', () async {
      final stream = streamEitherTryCatch<int>(
        () => Stream<int>.error(StateError('x'), StackTrace.current),
        network: _FakeNetwork(),
      );
      await expectLater(stream, emitsError(isA<StateError>()));
    });
  });
}
