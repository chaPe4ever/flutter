import 'package:analytics/analytics.dart';

///
final class FakeAnalyticsImpl implements AnalyticsBase {
  @override
  Future<void> logEvent({required AnalyticsEvent analyticsEvent}) =>
      Future.value();

  @override
  Future<void> setAnalytics({required bool enabled}) => Future.value();

  @override
  Future<void> setCurrentScreen({required String? screenName}) =>
      Future.value();

  @override
  Future<void> setUserId({String? id}) => Future.value();
}
