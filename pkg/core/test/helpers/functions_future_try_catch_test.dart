import 'package:core/core.dart';
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

void main() {
  tearDown(FunctionsAuthFailureHandler.reset);

  group('functionsFutureTryCatch unauthenticated', () {
    test('invokes FunctionsAuthFailureHandler then rethrows', () async {
      final logger = _FakeLogger();
      var handlerCalls = 0;
      FunctionsAuthFailureHandler.onUnauthenticated = () {
        handlerCalls++;
      };

      await expectLater(
        () => functionsFutureTryCatch<void>(
          () async {
            throw FirebaseFunctionsException(
              code: 'unauthenticated',
              message: 'The request was not authorized',
            );
          },
          logger: logger,
          errorMessageKey: 'fetch_failed',
        ),
        throwsA(
          isA<FirestoreFunctionsException>().having(
            (e) => e.innerCode,
            'innerCode',
            'unauthenticated',
          ),
        ),
      );

      expect(handlerCalls, 1);
      expect(logger.errors, isNotEmpty);
    });

    test('does not invoke handler for other function codes', () async {
      final logger = _FakeLogger();
      var handlerCalls = 0;
      FunctionsAuthFailureHandler.onUnauthenticated = () {
        handlerCalls++;
      };

      await expectLater(
        () => functionsFutureTryCatch<void>(
          () async {
            throw FirebaseFunctionsException(
              code: 'permission-denied',
              message: 'nope',
            );
          },
          logger: logger,
        ),
        throwsA(isA<FirestoreFunctionsException>()),
      );

      expect(handlerCalls, 0);
    });

    test('still throws when handler itself fails', () async {
      final logger = _FakeLogger();
      FunctionsAuthFailureHandler.onUnauthenticated = () {
        throw StateError('handler blew up');
      };

      await expectLater(
        () => functionsFutureTryCatch<void>(
          () async {
            throw FirebaseFunctionsException(
              code: 'unauthenticated',
              message: 'bad token',
            );
          },
          logger: logger,
        ),
        throwsA(isA<FirestoreFunctionsException>()),
      );

      expect(
        logger.errors.any((m) => m.contains('FunctionsAuthFailureHandler')),
        isTrue,
      );
    });
  });
}
