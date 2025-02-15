import 'package:core/interceptors/refresh_token_interceptor.dart';
import 'package:dio/dio.dart';

void invalidateDioInterceptors({
  required Dio dio,
  Iterable<Interceptor> interceptors = const [],
}) {
  dio.interceptors.clear();

  interceptors
      .whereType<RefreshTokenInterceptor>()
      .firstOrNull
      ?.resetMaxRetries();

  dio.interceptors.addAll(interceptors);
}
