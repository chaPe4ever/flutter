import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:firebase_crashlytics_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';

final fakeFirebaseCrashlyticsHostApi = FakeFirebaseCrashlyticsHostApi();

class _MockFirebaseAppWithCrashlytics implements TestFirebaseCoreHostApi {
  @override
  Future<CoreInitializeResponse> initializeApp(
    String appName,
    CoreFirebaseOptions initializeAppRequest,
  ) async {
    return CoreInitializeResponse(
      name: appName,
      options: CoreFirebaseOptions(
        apiKey: '123',
        projectId: '123',
        appId: '123',
        messagingSenderId: '123',
      ),
      pluginConstants: {
        'plugins.flutter.io/firebase_crashlytics': {
          'isCrashlyticsCollectionEnabled': true,
        },
      },
    );
  }

  @override
  Future<List<CoreInitializeResponse>> initializeCore() async {
    return [
      CoreInitializeResponse(
        name: defaultFirebaseAppName,
        options: CoreFirebaseOptions(
          apiKey: '123',
          projectId: '123',
          appId: '123',
          messagingSenderId: '123',
        ),
        pluginConstants: {
          'plugins.flutter.io/firebase_crashlytics': {
            'isCrashlyticsCollectionEnabled': true,
          },
        },
      ),
    ];
  }

  @override
  Future<CoreFirebaseOptions> optionsFromResource() async {
    return CoreFirebaseOptions(
      apiKey: '123',
      projectId: '123',
      appId: '123',
      messagingSenderId: '123',
    );
  }
}

void setupFirebaseCrashlyticsPlatformMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestFirebaseCoreHostApi.setUp(_MockFirebaseAppWithCrashlytics());
  TestFirebaseCrashlyticsHostApi.setUp(fakeFirebaseCrashlyticsHostApi);
}

class FakeFirebaseCrashlyticsHostApi implements TestFirebaseCrashlyticsHostApi {
  final List<String> calls = <String>[];

  void reset() {
    calls.clear();
  }

  @override
  Future<bool> checkForUnsentReports() async {
    calls.add('checkForUnsentReports');
    return true;
  }

  @override
  Future<void> crash() async {
    calls.add('crash');
  }

  @override
  Future<void> deleteUnsentReports() async {
    calls.add('deleteUnsentReports');
  }

  @override
  Future<bool> didCrashOnPreviousExecution() async {
    calls.add('didCrashOnPreviousExecution');
    return false;
  }

  @override
  Future<void> recordError(RecordErrorRequest request) async {
    calls.add('recordError');
  }

  @override
  Future<void> log(String message) async {
    calls.add('log');
  }

  @override
  Future<void> sendUnsentReports() async {
    calls.add('sendUnsentReports');
  }

  @override
  Future<bool> setCrashlyticsCollectionEnabled(bool enabled) async {
    calls.add('setCrashlyticsCollectionEnabled');
    return enabled;
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    calls.add('setUserIdentifier');
  }

  @override
  Future<void> setCustomKey(String key, String value) async {
    calls.add('setCustomKey');
  }
}
