import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shared/fakes.dart';

class _CountingInterceptor extends Interceptor {}

void main() {
  test('invalidateDioInterceptors replaces interceptors', () {
    final dio = Dio();
    dio.interceptors.add(_CountingInterceptor());

    invalidateDioInterceptors(
      dio: dio,
      interceptors: [_CountingInterceptor()],
    );

    expect(dio.interceptors.whereType<_CountingInterceptor>(), hasLength(1));
  });

  test('invalidateDioInterceptors resets refresh token retry counter', () {
    final dio = Dio();
    final interceptor =
        RefreshTokenInterceptor(
            dioRetry: dio,
            localStorageBase: FakeLocalStorage(),
            apiAuth: FakeApiAuthStrategy('token'),
            prettyDioLoggerInterceptor: PrettyDioLoggerExtension.logger,
          )
          ..maxRetries = 1
          ..resetMaxRetries();

    invalidateDioInterceptors(
      dio: dio,
      interceptors: [interceptor],
    );

    expect(dio.interceptors.whereType<RefreshTokenInterceptor>(), hasLength(1));
  });
}
