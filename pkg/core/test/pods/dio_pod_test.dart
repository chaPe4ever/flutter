import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dio pods', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('cancelTokenPod exposes a fresh cancel token', () {
      final token = container.read(cancelTokenPod);

      expect(token, isA<CancelToken>());
      expect(token.isCancelled, isFalse);
    });

    test('dioPod configures base url and json content type', () {
      const baseUrl = 'https://example.com';
      final dio = container.read(dioPod(baseUrl: baseUrl));

      expect(dio.options.baseUrl, baseUrl);
      expect(dio.options.contentType, Headers.jsonContentType);
      expect(dio.options.connectTimeout, const Duration(seconds: 10));
    });

    test('dioRetryPod and dioTokenPod share timeout defaults', () {
      const baseUrl = 'https://retry.example.com';
      final retry = container.read(dioRetryPod(baseUrl: baseUrl));
      final tokenClient = container.read(dioTokenPod(baseUrl: baseUrl));

      expect(retry.options.baseUrl, baseUrl);
      expect(tokenClient.options.receiveTimeout, const Duration(seconds: 10));
    });
  });
}
