import 'package:core/exceptions/core_exception.dart';
import 'package:core/exceptions/core_exceptions.dart';
import 'package:dio/dio.dart';

extension RequestOptionsX on RequestOptions {
  Options get options => Options(
        method: method,
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
        extra: extra,
        headers: headers,
        responseType: responseType,
        contentType: contentType,
        validateStatus: validateStatus,
        receiveDataWhenStatusError: receiveDataWhenStatusError,
        followRedirects: followRedirects,
        persistentConnection: persistentConnection,
        requestEncoder: requestEncoder,
        responseDecoder: responseDecoder,
        listFormat: listFormat,
      );
}

extension DioResponseX<T> on Response<T> {
  T getDataOrThrow({CoreException? customException}) => switch (this) {
        (final res) when res.data != null => res.data!,
        (_) => throw customException ?? UnknownCoreException()
      };
}
