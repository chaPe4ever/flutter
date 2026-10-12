import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUserInfo extends Mock implements UserInfo {}

class MockAdditionalUserInfo extends Mock implements AdditionalUserInfo {}

class MockActionCodeInfo extends Mock implements ActionCodeInfo {}

void registerAuthFallbacks() {
  registerFallbackValue(
    EmailAuthProvider.credential(
      email: 'fallback@example.com',
      password: 'secret12',
    ),
  );
  registerFallbackValue(GoogleAuthProvider());
}
