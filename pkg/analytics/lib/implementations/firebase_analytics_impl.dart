import 'package:analytics/analytics.dart';
import 'package:core/core.dart' show CoreException;

///
final class FirebaseAnalyticsImpl implements AnalyticsBase {
  ///
  FirebaseAnalyticsImpl({required FirebaseAnalytics analytics})
    : _analytics = analytics;

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent({required AnalyticsEvent analyticsEvent}) async {
    try {
      switch (analyticsEvent) {
        case FirebaseAnalyticsEvent(
          name: final name,
          parameters: final parameters,
        ):
          await _analytics.logEvent(name: name, parameters: parameters);
      }
    } on CoreException {
      rethrow;
    } catch (e, st) {
      throw UnknownAnalyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> setAnalytics({required bool enabled}) {
    try {
      return _analytics.setAnalyticsCollectionEnabled(enabled);
    } catch (e, st) {
      throw UnknownAnalyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> setCurrentScreen({required String? screenName}) {
    try {
      return _analytics.logScreenView(screenName: screenName);
    } catch (e, st) {
      throw UnknownAnalyticsException(innerError: e, st: st);
    }
  }

  @override
  Future<void> setUserId({String? id}) {
    try {
      return _analytics.setUserId(id: id);
    } catch (e, st) {
      throw UnknownAnalyticsException(innerError: e, st: st);
    }
  }
}
