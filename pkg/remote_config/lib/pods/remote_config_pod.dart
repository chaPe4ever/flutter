import 'package:core/core.dart';
import 'package:remote_config/contracts/contracts.dart';
import 'package:remote_config/implementations/firebase_remote_config_impl.dart';
import 'package:remote_config/pods/firebase_remote_config_pod.dart';
import 'package:riverpod/riverpod.dart';

part 'remote_config_pod.g.dart';

///
@Riverpod(keepAlive: true)
RemoteConfigBase remoteConfig(Ref ref) {
  final remoteConfig = FirebaseRemoteConfigImpl(
    firebaseRemoteConfig: ref.watch(firebaseRemoteConfigPod),
  );

  ref.onDispose(remoteConfig.dispose);

  return remoteConfig;
}
