import 'package:core/core.dart';
import 'package:crashlytics/implementations/sentry_and_firebase_crashlytics_impl.dart';
import 'package:crashlytics/pods/crashlytics_pod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/crashlytics_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(ensureDefaultFirebaseApp);

  test('crashlyticsPod exposes SentryAndFirebaseCrashlyticsImpl', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(crashlyticsPod),
      isA<SentryAndFirebaseCrashlyticsImpl>(),
    );
  });
}
