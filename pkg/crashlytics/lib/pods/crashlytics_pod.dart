import 'package:core/core.dart';
import 'package:crashlytics/crashlytics.dart';

part 'crashlytics_pod.g.dart';

///
@Riverpod(keepAlive: true)
CrashlyticsBase crashlytics(Ref ref) =>
    FirebaseCrashlyticsImpl(crashlytics: FirebaseCrashlytics.instance);
