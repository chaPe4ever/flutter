import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shared/fakes.dart';

void main() {
  group('RefreshTokenInterceptor', () {
    late FakeLocalStorage storage;
    late Dio dioRetry;
    late RefreshTokenInterceptor interceptor;

    setUp(() {
      storage = FakeLocalStorage();
      dioRetry = Dio(BaseOptions(baseUrl: 'https://api.test'));
      interceptor = RefreshTokenInterceptor(
        dioRetry: dioRetry,
        localStorageBase: storage,
        apiAuth: FakeApiAuthStrategy('fresh-token'),
        prettyDioLoggerInterceptor: PrettyDioLoggerExtension.logger,
      );
      dioRetry.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response<dynamic>(
                requestOptions: options,
                statusCode: 200,
                data: {'ok': true},
              ),
            );
          },
        ),
      );
    });

    test('onRequest sets Authorization header from storage', () async {
      await storage.write(kApiAuthTokenKey, 'stored-token');
      final options = RequestOptions(path: '/resource');
      final handler = _CapturingRequestHandler();

      await interceptor.onRequest(options, handler);

      expect(
        options.headers['Authorization'],
        'Bearer stored-token',
      );
      expect(handler.forwarded, same(options));
    });

    test('onResponse forwards the response', () {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 200,
      );
      final handler = _CapturingResponseHandler();

      interceptor.onResponse(response, handler);

      expect(handler.forwarded, same(response));
    });

    test('onError refreshes token and resolves retry on 401', () async {
      await storage.write(kApiAuthTokenKey, 'old-token');
      final requestOptions = RequestOptions(
        path: '/resource',
        baseUrl: 'https://api.test',
        headers: {'Authorization': 'Bearer old-token'},
      );
      final err = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );
      final handler = _CapturingErrorHandler();

      await interceptor.onError(err, handler);

      expect(await storage.read<String>(kApiAuthTokenKey), 'fresh-token');
      expect(handler.resolved, isNotNull);
      expect(handler.resolved!.statusCode, 200);
    });

    test('onError rejects non-auth failures unchanged', () async {
      final requestOptions = RequestOptions(path: '/resource');
      final err = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 500,
        ),
      );
      final handler = _CapturingErrorHandler();

      await interceptor.onError(err, handler);

      expect(handler.rejected, same(err));
      expect(handler.resolved, isNull);
    });

    test('resetMaxRetries allows another refresh cycle', () async {
      interceptor.maxRetries = 1;
      final requestOptions = RequestOptions(
        path: '/resource',
        baseUrl: 'https://api.test',
        headers: {'Authorization': 'Bearer old-token'},
      );
      final err = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 403,
        ),
      );
      final handler = _CapturingErrorHandler();

      await interceptor.onError(err, handler);
      await interceptor.onError(err, handler);
      interceptor.resetMaxRetries();
      await interceptor.onError(err, handler);

      expect(handler.resolvedCount, 2);
    });

    test('onError rejects when token refresh throws DioException', () async {
      final dioRetry = Dio(BaseOptions(baseUrl: 'https://api.test'));
      final interceptor = RefreshTokenInterceptor(
        dioRetry: dioRetry,
        localStorageBase: storage,
        apiAuth: _ThrowingApiAuth(
          DioException(
            requestOptions: RequestOptions(path: '/token'),
            type: DioExceptionType.connectionError,
          ),
        ),
        prettyDioLoggerInterceptor: PrettyDioLoggerExtension.logger,
      );
      final requestOptions = RequestOptions(path: '/resource');
      final err = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );
      final handler = _CapturingErrorHandler();

      await interceptor.onError(err, handler);

      expect(handler.rejected, isA<DioException>());
    });

    test(
      'onError rejects when token refresh throws generic Exception',
      () async {
        final dioRetry = Dio(BaseOptions(baseUrl: 'https://api.test'));
        final interceptor = RefreshTokenInterceptor(
          dioRetry: dioRetry,
          localStorageBase: storage,
          apiAuth: _ThrowingApiAuth(Exception('token fail')),
          prettyDioLoggerInterceptor: PrettyDioLoggerExtension.logger,
        );
        final requestOptions = RequestOptions(path: '/resource');
        final err = DioException(
          requestOptions: requestOptions,
          response: Response<dynamic>(
            requestOptions: requestOptions,
            statusCode: 403,
          ),
        );
        final handler = _CapturingErrorHandler();

        await interceptor.onError(err, handler);

        expect(handler.rejected, isA<DioException>());
      },
    );

    test('onError retries multipart uploads with rebuilt form data', () async {
      final tempFile = File('${Directory.systemTemp.path}/core_upload.bin');
      await tempFile.writeAsString('payload');
      addTearDown(tempFile.deleteSync);

      final requestOptions = RequestOptions(
        path: '/upload',
        baseUrl: 'https://api.test',
        headers: {'Authorization': 'Bearer old-token'},
        extra: {
          kMultiPartFormData: _UploadPart(
            filePath: tempFile.path,
            fileMapKey: 'file',
          ),
        },
      );
      final err = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );
      final handler = _CapturingErrorHandler();

      await interceptor.onError(err, handler);

      expect(handler.resolved, isNotNull);
    });
  });
}

final class _ThrowingApiAuth implements ApiAuthStrategy {
  _ThrowingApiAuth(this.error);

  final Exception error;

  @override
  Future<String> getAccessToken() async => throw error;
}

final class _UploadPart extends MultiPartFormDataModelBase {
  _UploadPart({required this.filePath, required this.fileMapKey});

  @override
  final String filePath;

  @override
  final String fileMapKey;
}

final class _CapturingRequestHandler extends RequestInterceptorHandler {
  RequestOptions? forwarded;

  @override
  void next(RequestOptions requestOptions) {
    forwarded = requestOptions;
  }
}

final class _CapturingResponseHandler extends ResponseInterceptorHandler {
  Response<dynamic>? forwarded;

  @override
  void next(Response<dynamic> response) {
    forwarded = response;
  }
}

final class _CapturingErrorHandler extends ErrorInterceptorHandler {
  Response<dynamic>? resolved;
  DioException? rejected;
  int resolvedCount = 0;

  @override
  void resolve(Response<dynamic> response) {
    resolved = response;
    resolvedCount++;
  }

  @override
  void reject(DioException err, [bool callFollowingErrorInterceptor = false]) {
    rejected = err;
  }
}
