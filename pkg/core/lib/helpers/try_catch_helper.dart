import 'package:cloud_functions/cloud_functions.dart';
import 'package:core/core.dart';
import 'package:core/helpers/dio_interceptors_helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';

/// A generic try catch helper function.
///
/// Might throw [CoreException]
Stream<T> firestoreStreamTryCatch<T>(
  Stream<T> Function() cb, {
  required LoggerBase logger,
}) async* {
  yield* cb().handleError((Object e, StackTrace st) {
    if (e is FirebaseException) {
      logger.e(e.message ?? e.code, e: e, st: st);
      throw FirestoreException(
        innerMessage: e.message,
        innerCode: e.code,
        innerError: e,
        st: st,
      );
    } else if (e is CoreException) {
      logger.e(e.messageKey.tr(), e: e, st: st);
      throw e;
    } else {
      logger.e(
        StackTraceLoggerHelper.st(st).toString(),
        e: e,
        st: switch (st) {
          StackTrace.empty => StackTrace.current,
          _ => st,
        },
      );
      throw UnknownCoreException(
        innerError: e,
        st: switch (st) {
          StackTrace.empty => StackTrace.current,
          _ => st,
        },
      );
    }
  });
}

/// A generic try catch helper function.
///
/// Might throw [CoreException]
Future<T> firestoreFutureTryCatch<T>(
  Future<T> Function() cb, {
  required LoggerBase logger,
}) => cb().then(id).catchError((Object e, StackTrace st) {
  if (e is FirebaseException) {
    logger.e(e.message ?? e.code, e: e, st: st);
    throw FirestoreException(
      innerMessage: e.message,
      innerCode: e.code,
      innerError: e,
      st: st,
    );
  } else if (e is CoreException) {
    logger.e(e.messageKey.tr(), e: e, st: st);
    throw e;
  } else if (e is DioException) {
    logger.e(e.response?.statusMessage ?? e.type.name, e: e, st: e.stackTrace);
    throw DioClientException(
      innerError: e,
      innerCode: e.response?.statusCode?.toString() ?? '',
      innerMessage: e.response?.statusMessage ?? e.type.name,
      st: e.stackTrace,
    );
  } else {
    logger.e(
      StackTraceLoggerHelper.st(st).toString(),
      e: e,
      st: switch (st) {
        StackTrace.empty => StackTrace.current,
        _ => st,
      },
    );
    throw UnknownCoreException(
      innerError: e,
      st: switch (st) {
        StackTrace.empty => StackTrace.current,
        _ => st,
      },
    );
  }
});

/// A generic try catch helper function.
///
/// Might throw [CoreException]
Future<T> functionsFutureTryCatch<T>(
  Future<T> Function() cb, {
  required LoggerBase logger,
  T Function(CoreException e, StackTrace st)? onFunctionsCustomExCb,
}) => cb().then(id).catchError((Object e, StackTrace st) {
  if (e is FirebaseFunctionsException) {
    logger.e(e.message ?? e.code, e: e, st: st);
    final functionsEx = FirestoreFunctionsException(
      messageKey: e.message ?? e.code,
      innerMessage: e.message,
      innerCode: e.code,
      innerError: e,
      st: st,
    );
    if (onFunctionsCustomExCb != null) {
      return onFunctionsCustomExCb(functionsEx, st);
    }
    throw functionsEx;
  } else if (e is CoreException) {
    logger.e(e.messageKey.tr(), e: e, st: st);
    throw e;
  } else {
    logger.e(
      StackTraceLoggerHelper.st(st).toString(),
      e: e,
      st: switch (st) {
        StackTrace.empty => StackTrace.current,
        _ => st,
      },
    );
    throw UnknownCoreException(
      innerError: e,
      st: switch (st) {
        StackTrace.empty => StackTrace.current,
        _ => st,
      },
    );
  }
});

/// Future Option try catch helper function.
Future<Option<CoreException>> futureOptionTryCatch(
  Future<void> Function() cb, {
  required NetworkBase network,
}) async {
  if (await network.isConnected) {
    return cb()
        .then((_) => none<CoreException>())
        .catchError(
          (Object e, StackTrace st) =>
              _eitherErrorHandlerCb<Unit>(e, st).swap().toOption(),
        );
  } else {
    return const Some(NoNetworkException());
  }
}

/// Future Either try catch helper function.
Future<Either<CoreException, T>> futureEitherTryCatch<T>(
  Future<T> Function() cb, {
  required NetworkBase network,
  Duration cacheDuration = Duration.zero,
}) async {
  if (await network.isConnected) {
    if (cacheDuration.inSeconds >= 1) {
      return AsyncCache<Either<CoreException, T>>(cacheDuration).fetch(
        () => cb()
            .then(right<CoreException, T>)
            .catchError(_eitherErrorHandlerCb<T>),
      );
    } else {
      return cb()
          .then(right<CoreException, T>)
          .catchError(_eitherErrorHandlerCb<T>);
    }
  } else {
    return const Left(NoNetworkException());
  }
}

/// Future Either try catch helper function.
Stream<Either<CoreException, T>> streamEitherTryCatch<T>(
  Stream<T> Function() cb, {
  required NetworkBase network,
}) async* {
  if (await network.isConnected) {
    yield* cb()
        .handleError((Object e, StackTrace st) {
          return Stream.value(_eitherErrorHandlerCb<T>(e, st));
        })
        .map(right);
  } else {
    yield const Left(NoNetworkException());
  }
}

/// Dio error handler helper
///
/// Might throw [CoreException]
Future<T> dioTryCatch<T>(
  Future<T> Function() cb, {
  required LoggerBase logger,
  required Dio dio,
  Iterable<Interceptor> interceptors = const [],
}) {
  invalidateDioInterceptors(dio: dio, interceptors: interceptors);
  return cb().then(id).catchError((Object e, StackTrace st) {
    if (e is CoreException) {
      logger.e(e.messageKey.tr(), e: e, st: st);
      throw e;
    } else if (e is DioException) {
      logger.e(
        'ErrorType: ${e.type.name} | StatusMessage: '
        '${e.response?.statusMessage} | ResponseData: '
        '${e.response?.data} ',
        e: e,
        st: e.stackTrace,
      );
      throw DioClientException(
        innerError: e,
        innerCode: e.response?.statusCode?.toString() ?? '',
        innerMessage: e.response?.statusMessage ?? e.type.name,
        st: e.stackTrace,
      );
    } else {
      logger.e(
        StackTraceLoggerHelper.st(st).toString(),
        e: e,
        st: switch (st) {
          StackTrace.empty => StackTrace.current,
          _ => st,
        },
      );
      throw UnknownCoreException(
        innerError: e,
        st: switch (st) {
          StackTrace.empty => StackTrace.current,
          _ => st,
        },
      );
    }
  });
}

Future<T> futureTryCatch<T>(
  Future<T> Function() cb, {
  required NetworkBase network,
  Duration cacheDuration = Duration.zero,
}) async {
  if (await network.isConnected ||
      AppModeHelper().currentMode == AppModeEnum.fake) {
    if (cacheDuration.inSeconds >= 1) {
      return AsyncCache<T>(
        cacheDuration,
      ).fetch(() => cb().catchError(_errorThroableCb));
    } else {
      return cb().catchError(_errorThroableCb);
    }
  } else {
    throw const NoNetworkException();
  }
}

/// Future Either try catch helper function.
Stream<T> streamTryCatch<T>(
  Stream<T> Function() cb, {
  required NetworkBase network,
}) async* {
  if (await network.isConnected) {
    yield* cb().handleError((Object e, StackTrace st) {
      final error = e.toCoreException();

      Log.error(
        'Error: $e, innerError: ${error.innerError}, inner msg: ${error.innerMessage}',
        st: st,
      );
      throw error;
    });
  } else {
    throw const NoNetworkException();
  }
}

// Private methods

// Either error handler callback
Either<CoreException, T> _eitherErrorHandlerCb<T>(Object e, StackTrace st) {
  if (e is CoreException) {
    return left<CoreException, T>(e);
  } else {
    return left<CoreException, T>(
      UnknownCoreException(
        innerError: e,
        st: switch (st) {
          StackTrace.empty => StackTrace.current,
          _ => st,
        },
      ),
    );
  }
}

Never _errorThroableCb(Object e, StackTrace st) {
  Log.error(e, st: st);
  if (e is CoreException) {
    throw e;
  } else {
    throw UnknownCoreException(
      innerError: e,
      st: switch (st) {
        StackTrace.empty => StackTrace.current,
        _ => st,
      },
    );
  }
}
