import 'package:core/core.dart';

part 'pretty_dio_logger_interceptor.g.dart';

@riverpod
PrettyDioLogger prettyDioLoggerInterceptor(Ref ref) => PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      maxWidth: 80,
      logPrint: (Object e) => ref.watch(loggerPod).d(e.toString()),
    );
