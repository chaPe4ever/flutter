import 'package:core/core.dart';

part 'dio_pod.g.dart';

/// Keep the pod singleton
@riverpod
CancelToken cancelToken(Ref ref) => CancelToken();

/// The default dio http client
@riverpod
Dio dio(Ref ref, {required String baseUrl}) => Dio(
  BaseOptions(
    baseUrl: baseUrl,
    contentType: Headers.jsonContentType,
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

/// The dio http client used only for retrying the call inside interceptor
@riverpod
Dio dioRetry(Ref ref, {required String baseUrl}) => Dio(
  BaseOptions(
    baseUrl: baseUrl,
    contentType: Headers.jsonContentType,
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

/// The dio http client used only for making token requests
@riverpod
Dio dioToken(Ref ref, {required String baseUrl}) => Dio(
  BaseOptions(
    baseUrl: baseUrl,
    contentType: Headers.jsonContentType,
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);
