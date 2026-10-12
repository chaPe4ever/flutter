import 'package:crashlytics/implementations/fake_crashlytics_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeCrashlyticsImpl', () {
    late FakeCrashlyticsImpl crashlytics;

    setUp(() {
      crashlytics = FakeCrashlyticsImpl();
    });

    test('init completes without side effects', () async {
      await expectLater(crashlytics.init(), completes);
    });

    test('setCrashlytics completes without side effects', () async {
      await expectLater(crashlytics.setCrashlytics(enabled: true), completes);
      await expectLater(crashlytics.setCrashlytics(enabled: false), completes);
    });

    test('setUserId completes without side effects', () async {
      await expectLater(
        crashlytics.setUserId(userId: 'user-1'),
        completes,
      );
    });

    test('captureException completes without side effects', () async {
      await expectLater(
        crashlytics.captureException(StateError('noop')),
        completes,
      );
    });

    test('logEvent completes without side effects', () async {
      await expectLater(
        crashlytics.logEvent(message: 'noop'),
        completes,
      );
    });

    test('testCrash completes without side effects', () {
      expect(() => crashlytics.testCrash(), returnsNormally);
    });
  });
}
