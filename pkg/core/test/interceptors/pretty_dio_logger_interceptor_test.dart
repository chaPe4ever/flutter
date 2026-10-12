import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shared/fakes.dart';

void main() {
  group('PrettyDioLoggerExtension', () {
    test('logger enables request and response logging', () {
      final logger = PrettyDioLoggerExtension.logger;

      expect(logger.requestHeader, isTrue);
      expect(logger.requestBody, isTrue);
      expect(logger.responseHeader, isTrue);
      expect(logger.maxWidth, 80);
    });
  });

  group('prettyDioLoggerInterceptor', () {
    test('uses loggerPod for logPrint', () {
      final fakeLogger = FakeLogger();
      final container = ProviderContainer(
        overrides: [
          loggerPod.overrideWithValue(fakeLogger),
        ],
      );
      addTearDown(container.dispose);

      final interceptor = container.read(prettyDioLoggerInterceptorPod);

      interceptor.logPrint.call('dio-log-line');

      expect(fakeLogger.debugMessages, contains('dio-log-line'));
    });
  });
}
