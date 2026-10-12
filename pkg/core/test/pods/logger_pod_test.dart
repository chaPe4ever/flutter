import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shared/fakes.dart';

void main() {
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  group('loggerPod', () {
    test('returns a LoggerBase implementation by default', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final logger = container.read(loggerPod);

      expect(logger, isA<LoggerBase>());
      expect(() => logger.d('hello'), returnsNormally);
    });

    test('uses iOS printer configuration when platform is iOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(() => container.read(loggerPod).d('ios-log'), returnsNormally);
    });

    test('supports overrideWithValue', () {
      final fake = FakeLogger();
      final container = ProviderContainer(
        overrides: [loggerPod.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);

      container.read(loggerPod).e('failed');

      expect(fake.errorMessages, contains('failed'));
    });
  });
}
