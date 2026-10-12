import 'package:authentication/exceptions/auth_exceptions.dart';
import 'package:authentication/utils/firebase_auth_try_catch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/auth_dartz.dart';

import '../helpers/fake_logger.dart';

void main() {
  late FakeLogger logger;

  setUp(() {
    logger = FakeLogger();
  });

  group('futureOptionAuthTryCatch', () {
    test('returns none when the callback succeeds', () async {
      final result = await futureOptionAuthTryCatch(
        () async {},
        logger: logger,
      );

      expect(result, authNone());
    });

    test('maps FirebaseAuthException to some left', () async {
      final result = await futureOptionAuthTryCatch(
        () async => throw FirebaseAuthException(code: 'user-not-found'),
        logger: logger,
      );

      expect(result.isSome(), isTrue);
      result.fold(
        () => fail('expected some'),
        (ex) => expect(ex, isA<FirebaseAuthRawException>()),
      );
      expect(logger.errorMessages, isNotEmpty);
    });

    test(
      'uses customException for FirebaseAuthException when provided',
      () async {
        final result = await futureOptionAuthTryCatch(
          () async => throw FirebaseAuthException(code: 'network'),
          logger: logger,
          customException: const SignOutFailedException(),
        );

        expect(result, authSome(const SignOutFailedException()));
      },
    );

    test('maps AuthenticationEx to some left', () async {
      const ex = NoSignedInUserException();

      final result = await futureOptionAuthTryCatch(
        () async => throw ex,
        logger: logger,
      );

      expect(result, authSome(ex));
    });

    test('maps unknown errors to UnknownAuthException', () async {
      final result = await futureOptionAuthTryCatch(
        () async => throw StateError('boom'),
        logger: logger,
      );

      expect(result.isSome(), isTrue);
      result.fold(
        () => fail('expected some'),
        (ex) => expect(ex, isA<UnknownAuthException>()),
      );
    });
  });

  group('futureEitherAuthTryCatch', () {
    test('returns right when the callback succeeds', () async {
      final result = await futureEitherAuthTryCatch(
        () async => 42,
        logger: logger,
      );

      expect(result, right<AuthenticationEx, int>(42));
    });

    test('maps FirebaseAuthException to left', () async {
      final result = await futureEitherAuthTryCatch(
        () async => throw FirebaseAuthException(
          code: 'invalid-credential',
          message: 'bad creds',
        ),
        logger: logger,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (ex) => expect(ex, isA<FirebaseAuthRawException>()),
        (_) => fail('expected left'),
      );
    });

    test('uses customException when provided', () async {
      final result = await futureEitherAuthTryCatch(
        () async => throw FirebaseAuthException(code: 'x'),
        logger: logger,
        customException: const IsEmailVerifiedFailedException(),
      );

      expect(result, authLeft<int>(const IsEmailVerifiedFailedException()));
    });

    test('maps AuthenticationEx to left', () async {
      const ex = ResetPasswordFailedException();

      final result = await futureEitherAuthTryCatch(
        () async => throw ex,
        logger: logger,
      );

      expect(result, authLeft<int>(ex));
    });

    test('uses StackTrace.current when stack trace is empty', () async {
      final result = await futureEitherAuthTryCatch(
        () => Future<void>.error(Object(), StackTrace.empty),
        logger: logger,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (ex) {
          expect(ex, isA<UnknownAuthException>());
          expect(ex.st, isNot(StackTrace.empty));
        },
        (_) => fail('expected left'),
      );
    });
  });
}
