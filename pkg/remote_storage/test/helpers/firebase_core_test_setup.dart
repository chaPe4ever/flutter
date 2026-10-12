import 'package:core/core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';

const remoteStorageTestFirebaseOptions = FirebaseOptions(
  apiKey: 'api-key',
  appId: '1:1:web:abc',
  messagingSenderId: '1',
  projectId: 'project-id',
  storageBucket: 'test-bucket.appspot.com',
);

class _RemoteStorageFirebaseCoreMock implements TestFirebaseCoreHostApi {
  @override
  Future<CoreInitializeResponse> initializeApp(
    String appName,
    CoreFirebaseOptions initializeAppRequest,
  ) async {
    return CoreInitializeResponse(
      name: appName,
      options: initializeAppRequest,
      pluginConstants: {},
    );
  }

  @override
  Future<List<CoreInitializeResponse>> initializeCore() async => [];

  @override
  Future<CoreFirebaseOptions> optionsFromResource() async {
    return CoreFirebaseOptions(
      apiKey: remoteStorageTestFirebaseOptions.apiKey,
      appId: remoteStorageTestFirebaseOptions.appId,
      messagingSenderId: remoteStorageTestFirebaseOptions.messagingSenderId,
      projectId: remoteStorageTestFirebaseOptions.projectId,
      storageBucket: remoteStorageTestFirebaseOptions.storageBucket,
    );
  }
}

Future<void> setupRemoteStorageFirebaseCore() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestFirebaseCoreHostApi.setUp(_RemoteStorageFirebaseCoreMock());
  try {
    await Firebase.initializeApp(options: remoteStorageTestFirebaseOptions);
  } on FirebaseException catch (error) {
    if (error.code != 'duplicate-app') {
      rethrow;
    }
  }
}
