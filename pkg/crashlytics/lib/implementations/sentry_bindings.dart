import 'package:crashlytics/constants/crashlytics_constants.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Abstraction over static [Sentry] APIs for testing and production wiring.
abstract interface class SentryCrashlyticsBindings {
  /// Captures an exception in Sentry.
  Future<void> captureException(
    dynamic exception, {
    StackTrace? stackTrace,
  });

  /// Captures a structured event in Sentry.
  Future<void> captureEvent(SentryEvent event);

  /// Replaces the active Sentry client (e.g. when disabling collection).
  void bindClient(SentryClient client);
}

/// Delegates to the real [Sentry] SDK.
final class DefaultSentryCrashlyticsBindings
    implements SentryCrashlyticsBindings {
  /// Creates production bindings.
  const DefaultSentryCrashlyticsBindings();

  @override
  Future<void> captureException(
    dynamic exception, {
    StackTrace? stackTrace,
  }) => Sentry.captureException(exception, stackTrace: stackTrace);

  @override
  Future<void> captureEvent(SentryEvent event) => Sentry.captureEvent(event);

  @override
  void bindClient(SentryClient client) => Sentry.bindClient(client);
}

/// Persists a user identifier in Sentry.
///
/// Placeholder until SDK wiring is final.
typedef SentryUserIdSetter = Future<void> Function(String userId);

/// Default no-op until Sentry user id API is confirmed.
Future<void> defaultSentryUserIdSetter(String userId) async {}

/// Builds a no-op [SentryClient] used when crash reporting is disabled.
SentryClient disabledSentryClient() =>
    SentryClient(SentryOptions(dsn: sentryDsn));
