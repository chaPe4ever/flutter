import 'package:crashlytics/contracts/crashlytics_base.dart';

final class FakeCrashlyticsImpl implements CrashlyticsBase {
  @override
  Future<void> init() => Future.value();

  @override
  Future<void> setCrashlytics({required bool enabled}) => Future.value();

  @override
  Future<void> setUserId({required String userId}) => Future.value();

  @override
  void testCrash() {}

  @override
  Future<void> captureException(dynamic error, {StackTrace? stackTrace}) =>
      Future.value();

  @override
  Future<void> logEvent({required String message}) => Future.value();
}
