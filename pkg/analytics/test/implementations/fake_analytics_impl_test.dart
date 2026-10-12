import 'package:analytics/implementations/fake_analytics_impl.dart';
import 'package:analytics/unions/analytics_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeAnalyticsImpl', () {
    late FakeAnalyticsImpl analytics;

    setUp(() {
      analytics = FakeAnalyticsImpl();
    });

    test('logEvent completes without side effects', () async {
      await expectLater(
        analytics.logEvent(
          analyticsEvent: FirebaseAnalyticsEvent(name: 'noop'),
        ),
        completes,
      );
    });

    test('setAnalytics completes without side effects', () async {
      await expectLater(analytics.setAnalytics(enabled: true), completes);
      await expectLater(analytics.setAnalytics(enabled: false), completes);
    });

    test('setUserId completes without side effects', () async {
      await expectLater(analytics.setUserId(id: 'user-1'), completes);
      await expectLater(analytics.setUserId(), completes);
    });

    test('setCurrentScreen completes without side effects', () async {
      await expectLater(
        analytics.setCurrentScreen(screenName: 'Home'),
        completes,
      );
      await expectLater(
        analytics.setCurrentScreen(screenName: null),
        completes,
      );
    });
  });
}
