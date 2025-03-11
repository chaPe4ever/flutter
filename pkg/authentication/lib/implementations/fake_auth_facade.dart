import 'package:authentication/contracts/auth_facade.dart';
import 'package:authentication/exceptions/auth_exceptions.dart';
import 'package:authentication/utils/value_objects.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Firebase authentication facade implementation
final class FakeAuthFacade implements AuthFacade {
  /// Constructor
  FakeAuthFacade()
    : _user = InMemoryStore<User?>(
        FakeUser(
          metadata: UserMetadata(0, 0),
          uid: faker.guid.guid(),
          email: faker.internet.email(),
          displayName: faker.person.name(),
          photoURL: faker.internet.httpsUrl(),
          phoneNumber: faker.phoneNumber.us(),
        ),
      );

  // Fields

  final InMemoryStore<User?> _user;

  // Methods
  @override
  Future<Either<AuthenticationEx, UserCredential>>
  registerWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
  }) async {
    try {
      _user.value = FakeUser(
        metadata: UserMetadata(0, 0),
        uid: faker.guid.guid(),
        email: email.requireValue,
        displayName: faker.person.name(),
        photoURL: faker.internet.httpsUrl(),
        phoneNumber: faker.phoneNumber.us(),
      );

      return right(
        FakeUserCredentialFactory.email(
          user: _user.value!,
          credential: EmailAuthProvider.credential(
            email: email.requireValue,
            password: password.requireValue,
          ),
          isNewUser: true,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code.contains('email-already-in-use')) {
        return left(const AuthEmailAlreadyInUseException());
      } else {
        return left(const AuthServerErrorException());
      }
    }
  }

  @override
  Future<Option<AuthenticationEx>> signInWithApple() async {
    throw UnimplementedError();
  }

  @override
  Future<Option<AuthenticationEx>> signInWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
  }) async {
    try {
      _user.value ??= FakeUser(
        metadata: UserMetadata(0, 0),
        uid: faker.guid.guid(),
        email: email.requireValue,
        displayName: faker.person.name(),
        photoURL: faker.internet.httpsUrl(),
        phoneNumber: faker.phoneNumber.us(),
      );

      await _user.value?.reload();
      if (_user.value?.emailVerified == false) {
        return some(const EmailNotVerifiedException());
      }
      return none();
    } on FirebaseAuthException catch (e) {
      if (e.code.contains('user-not-found') ||
          e.code.contains('wrong-password') ||
          e.code.contains('invalid-credential') ||
          e.code.contains('INVALID_LOGIN_CREDENTIALS')) {
        return some(const AuthInvalidEmailAndPasswordCombinationException());
      } else {
        return some(const AuthServerErrorException());
      }
    }
  }

  @override
  Future<Option<AuthenticationEx>> signInWithFacebook() {
    throw UnimplementedError();
  }

  @override
  Future<Option<AuthenticationEx>> signInWithGithub() {
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthenticationEx, UserCredential>> signInWithCredential({
    required AuthCredential authCredential,
  }) => Future.value(
    right(FakeUserCredential(user: _user.value, credential: authCredential)),
  );

  @override
  Future<Option<AuthenticationEx>> signInWithGoogle() async {
    try {
      return none();
    } on FirebaseAuthException {
      return some(const AuthServerErrorException());
    }
  }

  @override
  Option<User> getSignedInUser() => optionOf(_user.value);

  @override
  Future<Option<AuthenticationEx>> signOut() async {
    _user.value = null;
    await _user.value?.reload();
    return none();
  }

  @override
  Future<Either<AuthenticationEx, bool>> isEmailVerified() async {
    final currentUser = _user.value;
    if (currentUser == null) {
      // Means there is no logged in user
      return left(const NoSignedInUserException());
    }
    await currentUser.reload();
    return right(currentUser.emailVerified);
  }

  @override
  Future<Option<AuthenticationEx>> sendEmailVerification({
    ActionCodeSettings? actionCodeSettings,
  }) async {
    final currentUser = _user.value;

    if (currentUser == null) {
      // Means there is no logged in user
      return some(const NoSignedInUserException());
    }

    await currentUser.sendEmailVerification(actionCodeSettings);
    return none();
  }

  @override
  Future<Either<AuthenticationEx, ActionCodeInfo>> checkActionCode({
    required String code,
  }) async => throw UnimplementedError();

  @override
  Future<Option<AuthenticationEx>> applyActionCode({
    required String code,
  }) async => throw UnimplementedError();

  @override
  Future<Option<AuthenticationEx>> sendPasswordResetEmail({
    required String emailAddress,
    ActionCodeSettings? actionCodeSettings,
  }) async => throw UnimplementedError();

  @override
  Future<Either<AuthenticationEx, String>> verifyPasswordResetCode({
    required String code,
  }) async => throw UnimplementedError();

  @override
  Future<Option<AuthenticationEx>> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async => throw UnimplementedError();

  @override
  Future<Option<AuthenticationEx>> setPersistence({
    required Persistence persistence,
  }) async => throw UnimplementedError();

  @override
  Future<Option<AuthenticationEx>> deleteCurrentUser() async {
    try {
      final currentUser = _user.value;

      if (currentUser == null) {
        // Means there is no logged in user

        return some(const NoSignedInUserException());
      }
      await currentUser.delete();
      _user.value = null;
      return none();
    } on FirebaseAuthException catch (e, st) {
      return e.code == 'requires-recent-login'
          ? some(const RequiresRecentLoginException())
          : some(
            FirebaseAuthRawException(
              innerError: e,
              innerMessage: e.message,
              innerCode: e.code,
              st: st,
            ),
          );
    }
  }

  @override
  Future<Option<AuthenticationEx>> updatePassword({
    required Password password,
  }) async {
    try {
      final currentUser = _user.value;

      if (currentUser == null) {
        // Means there is no logged in user
        return some(const NoSignedInUserException());
      }

      await currentUser.updatePassword(password.requireValue);

      return none();
    } on FirebaseAuthException catch (e, st) {
      return e.code == 'requires-recent-login'
          ? some(const RequiresRecentLoginException())
          : some(
            FirebaseAuthRawException(
              innerError: e,
              innerMessage: e.message,
              innerCode: e.code,
              st: st,
            ),
          );
    }
  }

  @override
  Future<Option<AuthenticationEx>> reAuthenticateWithPassword({
    required Password password,
  }) async {
    try {
      final currentUser = _user.value;

      if (currentUser == null) {
        // Means there is no logged in user
        return some(const NoSignedInUserException());
      }

      final email = currentUser.email;
      // Means signed in anonymously
      if (email == null) {
        return some(const UserSignedInUnonymouslyException());
      }

      await currentUser.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: email,
          password: password.requireValue,
        ),
      );

      return none();
    } on FirebaseAuthException catch (e, st) {
      return some(
        (e.code == 'wrong-password')
            ? const InvalidPasswordException()
            : FirebaseAuthRawException(
              innerError: e,
              innerMessage: e.message,
              innerCode: e.code,
              st: st,
            ),
      );
    }
  }

  @override
  Future<Either<AuthenticationEx, String>> get idToken async {
    try {
      final idToken = await _user.value?.getIdToken();

      if (idToken == null) {
        throw const NoSignedInUserException();
      }

      return right(idToken);
    } on AuthenticationEx catch (e) {
      return Left(e);
    } on FirebaseAuthException catch (e, st) {
      return Left(
        FirebaseAuthRawException(
          innerError: e,
          innerMessage: e.message,
          innerCode: e.code,
          st: st,
        ),
      );
    }
  }

  @override
  Stream<User?> authStateChanges() => _user.stream;

  @override
  void authChangeObserver({
    VoidCallback? onPreSignOut,
    VoidCallback? onSignOut,
    void Function(User user)? onSignIn,
  }) {
    _user.stream.listen((User? user) {
      if (user == null) {
        onSignOut?.call();
      } else {
        onSignIn?.call(user);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Stream<void> priorSignOutStream() {
    // TODO: implement priorSignOutListener
    throw UnimplementedError();
  }
}

class FakeUser implements User {
  const FakeUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.phoneNumber,
    required this.metadata,
    this.emailVerified = true,
    this.isAnonymous = false,
    this.tenantId,
  });

  @override
  final String uid;

  @override
  final String email;

  @override
  final String displayName;

  @override
  final String photoURL;

  @override
  final String phoneNumber;

  @override
  final bool emailVerified;

  @override
  final bool isAnonymous;

  @override
  final UserMetadata metadata;

  @override
  final String? tenantId;

  @override
  Future<void> delete() async {}

  @override
  List<UserInfo> get providerData => [];

  @override
  Future<void> reload() async {
    // Simulate reloading user data
  }

  @override
  Future<void> sendEmailVerification([
    ActionCodeSettings? actionCodeSettings,
  ]) async {
    // Simulate sending email verification
  }

  @override
  Future<UserCredential> reauthenticateWithCredential(
    AuthCredential credential,
  ) async {
    throw UnimplementedError(); // Implement based on your fake logic
  }

  @override
  Future<String> getIdToken([bool forceRefresh = false]) async {
    return faker.guid.guid(); // Return a fake token
  }

  @override
  Future<void> updateEmail(String newEmail) async {
    // Simulate email update
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    // Simulate password update
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    // Simulate profile update
  }

  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) async {
    throw UnimplementedError(); // Simulate linking credentials
  }

  @override
  Future<ConfirmationResult> linkWithPhoneNumber(
    String phoneNumber, [
    RecaptchaVerifier? verifier,
  ]) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> linkWithPopup(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<void> linkWithRedirect(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  MultiFactor get multiFactor => throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithPopup(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> reauthenticateWithProvider(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<void> reauthenticateWithRedirect(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  String? get refreshToken => throw UnimplementedError();

  @override
  Future<void> updateDisplayName(String? displayName) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePhotoURL(String? photoURL) {
    throw UnimplementedError();
  }

  @override
  Future<void> verifyBeforeUpdateEmail(
    String newEmail, [
    ActionCodeSettings? actionCodeSettings,
  ]) {
    throw UnimplementedError();
  }

  @override
  Future<User> unlink(String providerId) {
    throw UnimplementedError();
  }

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) {
    throw UnimplementedError();
  }
}

class FakeUserCredential implements UserCredential {
  /// Constructor for the fake user credential.
  const FakeUserCredential({
    required this.user,
    this.additionalUserInfo,
    this.credential,
  });

  @override
  final User? user;

  @override
  final AdditionalUserInfo? additionalUserInfo;

  @override
  final AuthCredential? credential;

  @override
  String toString() {
    return 'FakeUserCredential(user: $user, additionalUserInfo: $additionalUserInfo, credential: $credential)';
  }
}

/// Fake implementation of [AdditionalUserInfo].
class FakeAdditionalUserInfo implements AdditionalUserInfo {
  /// Constructor for the fake additional user info.
  const FakeAdditionalUserInfo({
    required this.isNewUser,
    required this.providerId,
    this.profile,
    this.username,
  });

  @override
  final bool isNewUser;

  @override
  final String? providerId;

  @override
  final Map<String, dynamic>? profile;

  @override
  final String? username;

  @override
  String toString() {
    return 'FakeAdditionalUserInfo(isNewUser: $isNewUser, providerId: $providerId, profile: $profile, username: $username)';
  }

  @override
  String? get authorizationCode => null;
}

extension FakeUserCredentialFactory on FakeUserCredential {
  /// Factory method for a fake Google sign-in user credential.
  static FakeUserCredential google({
    required String uid,
    required String email,
    required String displayName,
    required String photoURL,
    required String idToken,
    required String accessToken,
    bool isNewUser = false,
  }) {
    return FakeUserCredential(
      user: FakeUser(
        uid: uid,
        email: email,
        displayName: displayName,
        photoURL: photoURL,
        phoneNumber: faker.phoneNumber.us(),
        metadata: UserMetadata(0, 0),
      ),
      credential: GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      ),
      additionalUserInfo: FakeAdditionalUserInfo(
        isNewUser: isNewUser,
        providerId: GoogleAuthProvider.PROVIDER_ID,
      ),
    );
  }

  /// Factory method for a fake email/password user credential.
  static FakeUserCredential email({
    required User user,
    required AuthCredential credential,
    bool isNewUser = false,
  }) {
    return FakeUserCredential(
      user: user,
      credential: credential,
      additionalUserInfo: FakeAdditionalUserInfo(
        isNewUser: isNewUser,
        providerId: EmailAuthProvider.PROVIDER_ID,
      ),
    );
  }

  /// Factory method for a fake phone user credential.
  static FakeUserCredential phone({
    required String uid,
    required String phoneNumber,
    required String verificationId,
    required String smsCode,
    bool isNewUser = false,
  }) {
    return FakeUserCredential(
      user: FakeUser(
        uid: uid,
        email: faker.internet.email(),
        displayName: faker.person.name(),
        photoURL: faker.internet.httpsUrl(),
        phoneNumber: phoneNumber,
        metadata: UserMetadata(0, 0),
      ),
      credential: PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      ),
      additionalUserInfo: FakeAdditionalUserInfo(
        isNewUser: isNewUser,
        providerId: PhoneAuthProvider.PROVIDER_ID,
      ),
    );
  }
}

final fakeGoogleUserCredential = FakeUserCredentialFactory.google(
  uid: faker.guid.guid(),
  email: faker.internet.email(),
  displayName: faker.person.name(),
  photoURL: faker.internet.httpsUrl(),
  idToken: faker.jwt.valid(),
  accessToken: faker.jwt.valid(),
  isNewUser: true,
);

final fakePhoneUserCredential = FakeUserCredentialFactory.phone(
  uid: faker.guid.guid(),
  phoneNumber: faker.phoneNumber.us(),
  verificationId: 'fake-verification-id',
  smsCode: '123456',
);
