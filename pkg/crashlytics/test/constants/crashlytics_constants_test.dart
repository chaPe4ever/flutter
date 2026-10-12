import 'package:crashlytics/constants/crashlytics_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('kCrashlyticsPkgName matches the package name', () {
    expect(kCrashlyticsPkgName, 'crashlytics');
  });

  test('sentryDsn is configured for Sentry ingestion', () {
    expect(sentryDsn, startsWith('https://'));
    expect(sentryDsn, contains('sentry.io'));
  });
}
