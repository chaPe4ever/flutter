import 'dart:async';

import 'package:core/core.dart';

const String kApiAuthTokenKey = 'apiAuthTokenKey';
const String kMultiPartFormData = 'multi_part_form_data';

///
class RefreshTokenInterceptor implements Interceptor {
  /// Constructor
  RefreshTokenInterceptor({
    required Dio dioRetry,
    required LocalStorageBase localStorageBase,
    required ApiAuthStrategy apiAuth,
    required PrettyDioLogger prettyDioLoggerInterceptor,
  }) : _dioRetry = dioRetry,
       _localStorage = localStorageBase,
       _apiAuth = apiAuth {
    _dioRetry.interceptors
      ..clear()
      ..add(prettyDioLoggerInterceptor);
  }

  // Fields
  final Dio _dioRetry;
  final LocalStorageBase _localStorage;
  final ApiAuthStrategy _apiAuth;

  var _maxRetriesCounter = 0;

  // Properties
  int maxRetries = 5;

  // Getters
  String get accessToken => _localStorage.read<String>(kApiAuthTokenKey) ?? '';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $accessToken';

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      try {
        _handleMaxRetries(maxRetries: maxRetries);

        final accessToken = await _apiAuth.getAccessToken();

        await _localStorage.write(kApiAuthTokenKey, accessToken);

        err.requestOptions.headers.update(
          'Authorization',
          (value) => 'Bearer $accessToken',
        );

        return handler.resolve(await _retry(err.requestOptions));
      } on DioException catch (e) {
        handler.reject(e);
      } catch (er) {
        handler.reject(
          DioException(requestOptions: err.requestOptions, error: er),
        );
      }
    } else {
      handler.reject(err);
    }
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  void _handleMaxRetries({required int maxRetries}) {
    if (maxRetries <= _maxRetriesCounter++) {
      throw MaxRefreshTokenRetriesReached();
    }
  }

  // Methods
  void resetMaxRetries() {
    _maxRetriesCounter = 0;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    // If the request is a MultiFormPart file we need to recreate the FormData,
    // for that reason we use the extra to get the saved data
    if (requestOptions.extra.containsKey(kMultiPartFormData)) {
      final multiPartFormData =
          requestOptions.extra[kMultiPartFormData]
              as MultiPartFormDataModelBase?;
      if (multiPartFormData != null) {
        final multiPartFile = await MultipartFile.fromFile(
          multiPartFormData.filePath,
          contentType: multiPartFormData.contentType,
          filename: multiPartFormData.filename,
          headers: multiPartFormData.headers,
        );

        requestOptions.data = FormData.fromMap(
          {multiPartFormData.fileMapKey: multiPartFile},
          multiPartFormData.listFormat,
          multiPartFormData.camelCaseContentDisposition,
          multiPartFormData.boundaryName,
        );
      }
    }
    return _dioRetry.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: requestOptions.options,
    );
  }
}
