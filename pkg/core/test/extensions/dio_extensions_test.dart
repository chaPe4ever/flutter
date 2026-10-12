import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RequestOptionsX', () {
    test('options copies request fields', () {
      final request = RequestOptions(
        path: '/test',
        method: 'POST',
        headers: {'a': 'b'},
        extra: {'k': 'v'},
      );
      final options = request.options;
      expect(options.method, 'POST');
      expect(options.headers?['a'], 'b');
      expect(options.extra?['k'], 'v');
    });
  });

  group('DioResponseX', () {
    test('getDataOrThrow returns data when present', () {
      final response = Response<String>(
        requestOptions: RequestOptions(path: '/'),
        data: 'ok',
      );
      expect(response.getDataOrThrow(), 'ok');
    });

    test('getDataOrThrow throws default exception when data is null', () {
      final response = Response<String>(
        requestOptions: RequestOptions(path: '/'),
      );
      expect(
        response.getDataOrThrow,
        throwsA(isA<UnknownCoreException>()),
      );
    });

    test('getDataOrThrow throws custom exception when data is null', () {
      final response = Response<String>(
        requestOptions: RequestOptions(path: '/'),
      );
      const custom = NoNetworkException();
      expect(
        () => response.getDataOrThrow(customException: custom),
        throwsA(same(custom)),
      );
    });
  });
}
