import 'package:analytics/unions/analytics_event.dart';
import 'package:core/core.dart' show CoreException;

///
abstract interface class AnalyticsBase {
  /// For FirebaseAnalytics:
  /// Logs a custom Flutter Analytics event with the given
  /// [AnalyticsEvent.firebase.name] and event
  /// [AnalyticsEvent.firebase.parameters].
  ///
  /// The event can have up to 25 [AnalyticsEvent.firebase.parameters].
  /// Events with the same [AnalyticsEvent.firebase.name] must have the same
  /// [AnalyticsEvent.firebase.parameters]. Up to 500 event names are supported.
  ///
  /// The [AnalyticsEvent.firebase.name] of the event. Should contain
  /// 1 to 40 alphanumeric characters or underscores. The name must start
  /// with an alphabetic character. Some event names are reserved.
  /// The "firebase_", "google_" and "ga_" prefixes are reserved and should
  /// not be used. Note that event names are case-sensitive and that logging
  /// two events whose names differ only in case will result in two distinct
  /// events.
  ///
  /// The map of event [AnalyticsEvent.firebase.parameters]. Passing null
  /// indicates that the event has no parameters. Parameter names can be up
  /// to 40 characters long and must start with an alphabetic character and
  /// contain only alphanumeric characters and underscores. String, long and
  /// double param types are  supported. String parameter values can be up to
  /// 100 characters long. The "firebase_", "google_" and "ga_" prefixes are
  /// reserved and should not be used for parameter names.
  ///
  /// Might throw [CoreException]
  Future<void> logEvent({required AnalyticsEvent analyticsEvent});

  /// Sets whether analytics collection is enabled for this app on this device.
  ///
  /// Might throw [CoreException]
  Future<void> setAnalytics({required bool enabled});

  /// Sets the user ID property.
  ///
  /// Setting a null [id] removes the user id.
  ///
  /// Might throw [CoreException]
  Future<void> setUserId({String? id});

  /// Sets the current [screenName], which specifies the current visual context
  /// in your app.
  ///
  /// This helps identify the areas in your app where users spend their time
  /// and how they interact with your app.
  ///
  /// The [screenName] remain in effect until the
  /// current `Activity` (in Android) or `UIViewController` (in iOS) changes or
  /// a new call to [setCurrentScreen] is made.
  ///
  /// Setting a null [screenName] clears the current screen name.
  ///
  /// Might throw [CoreException]
  Future<void> setCurrentScreen({required String? screenName});
}
