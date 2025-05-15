import 'package:core/core.dart';
import 'package:crashlytics/crashlytics.dart';
import 'package:crashlytics/implementations/sentry_and_firebase_crashlytics_impl.dart';
import 'package:crashlytics/implementations/sentry_crashlytics_impl.dart';

part 'crashlytics_pod.g.dart';

///
@Riverpod(keepAlive: true)
CrashlyticsBase crashlytics(Ref ref) => SentryAndFirebaseCrashlyticsImpl(
  firebaseCrashlytics: FirebaseCrashlyticsImpl(
    crashlytics: FirebaseCrashlytics.instance,
  ),
  sentryCrashlytics: SentryCrashlyticsImpl(),
);
