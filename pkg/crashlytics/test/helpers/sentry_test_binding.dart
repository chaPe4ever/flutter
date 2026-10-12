import 'package:crashlytics/constants/crashlytics_constants.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void bindSentryTestClient() {
  Sentry.bindClient(SentryClient(SentryOptions(dsn: sentryDsn)));
}
