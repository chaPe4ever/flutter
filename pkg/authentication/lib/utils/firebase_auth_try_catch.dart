import 'package:authentication/authentication.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Future Option try catch helper function.
Future<Option<AuthenticationEx>> futureOptionAuthTryCatch(
  Future<void> Function() cb, {
  required LoggerBase logger,
  AuthenticationEx? customException,
}) async {
  return cb()
      .then((_) => none<AuthenticationEx>())
      .catchError(
        (Object e, StackTrace st) =>
            _eitherErrorHandlerCb<Unit>(
              e,
              st,
              customException: customException,
              logger: logger,
            ).swap().toOption(),
      );
}

/// Future Either try catch helper function.
Future<Either<AuthenticationEx, T>> futureEitherAuthTryCatch<T>(
  Future<T> Function() cb, {
  required LoggerBase logger,
  AuthenticationEx? customException,
}) async {
  return cb()
      .then(right<AuthenticationEx, T>)
      .catchError(
        (Object e, StackTrace st) => _eitherErrorHandlerCb<T>(
          e,
          st,
          customException: customException,
          logger: logger,
        ),
      );
}

// Either error handler callback
Either<AuthenticationEx, T> _eitherErrorHandlerCb<T>(
  Object e,
  StackTrace st, {
  required LoggerBase logger,
  AuthenticationEx? customException,
}) {
  if (e is FirebaseAuthException) {
    logger.e(e.message ?? e.code, e: e, st: st);
    return left(
      customException ??
          FirebaseAuthRawException(
            innerError: e,
            innerMessage: e.message,
            innerCode: e.code,
            st: st,
          ),
    );
  } else if (e is AuthenticationEx) {
    logger.e(e.messageKey, e: e, st: st);
    return left<AuthenticationEx, T>(e);
  } else {
    logger.e(
      StackTraceLoggerHelper.st(st).toString(),
      e: e,
      st: switch (st) {
        StackTrace.empty => StackTrace.current,
        _ => st,
      },
    );
    return left<AuthenticationEx, T>(
      UnknownAuthException(
        innerError: e,
        st: switch (st) {
          StackTrace.empty => StackTrace.current,
          _ => st,
        },
      ),
    );
  }
}
