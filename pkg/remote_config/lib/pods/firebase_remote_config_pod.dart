import 'package:core/core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

part 'firebase_remote_config_pod.g.dart';

@Riverpod(keepAlive: true)
FirebaseRemoteConfig firebaseRemoteConfig(Ref ref) =>
    FirebaseRemoteConfig.instance;
