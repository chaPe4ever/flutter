import 'package:authentication/authentication.dart';
import 'package:authentication/implementations/fake_auth_facade.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_facade_pod.g.dart';

///
@Riverpod(keepAlive: true)
AuthFacade authFacade(Ref ref) {
  final authFacade = switch (AppModeHelper().currentMode) {
    AppModeEnum.fake => FakeAuthFacade(),
    AppModeEnum.real => FirebaseAuthFacade(
      firebaseAuth: FirebaseAuth.instance,
      loggerBase: ref.read(loggerPod),
    ),
  };

  ref.onDispose(authFacade.dispose);
  return authFacade;
}
