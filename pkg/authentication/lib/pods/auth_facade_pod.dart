import 'package:authentication/authentication.dart';
import 'package:core/core.dart';

part 'auth_facade_pod.g.dart';

///
@Riverpod(keepAlive: true)
AuthFacade authFacade(Ref ref) {
  final authFacade = switch (AppModeHelper().currentMode) {
    AppModeEnum.fake => FakeAuthFacade(),
    AppModeEnum.real => FirebaseAuthFacade(
      firebaseAuth: ref.watch(firebaseAuthPod),
      loggerBase: ref.watch(loggerPod),
    ),
  };

  ref.onDispose(authFacade.dispose);
  return authFacade;
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}
