import 'package:authentication/exceptions/auth_exceptions.dart';
import 'package:authentication/implementations/fake_auth_facade.dart';
import 'package:authentication/utils/value_objects.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/auth_dartz.dart';

void main() {
  late FakeAuthFacade facade;

  EmailAddress validEmail() => EmailAddress('user@example.com');
  Password validPassword() => Password('secret12');

  setUp(() {
    facade = FakeAuthFacade();
  });

  group('FakeAuthFacade', () {
    test('getSignedInUser returns the seeded user', () {
      expect(facade.getSignedInUser().isSome(), isTrue);
    });

    test('registerWithEmailAndPassword stores the email on the user', () async {
      final email = validEmail();
      final password = validPassword();

      final result = await facade.registerWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('expected right'),
        (credential) {
          expect(credential.user?.email, email.requireValue);
          expect(credential.additionalUserInfo?.isNewUser, isTrue);
        },
      );
    });

    test('signInWithEmailAndPassword succeeds for a verified user', () async {
      final result = await facade.signInWithEmailAndPassword(
        email: validEmail(),
        password: validPassword(),
      );

      expect(result, authNone());
    });

    test('signInWithEmailAndPassword seeds a user after sign out', () async {
      await facade.signOut();

      final result = await facade.signInWithEmailAndPassword(
        email: validEmail(),
        password: validPassword(),
      );

      expect(result, authNone());
      expect(facade.getSignedInUser().isSome(), isTrue);
    });

    test('signInWithCredential returns a fake credential', () async {
      final credential = EmailAuthProvider.credential(
        email: 'user@example.com',
        password: 'secret12',
      );

      final result = await facade.signInWithCredential(
        authCredential: credential,
      );

      expect(result.isRight(), isTrue);
    });

    test('signInWithGoogle returns right null', () async {
      expect(await facade.signInWithGoogle(), authRight<User?>(null));
    });

    test('signOut clears the signed-in user', () async {
      expect(await facade.signOut(), authNone());
      expect(facade.getSignedInUser(), authUserNone());
    });

    test('isEmailVerified returns left when no user is signed in', () async {
      await facade.signOut();

      expect(
        await facade.isEmailVerified(),
        authLeft<bool>(const NoSignedInUserException()),
      );
    });

    test('isEmailVerified returns the user flag when signed in', () async {
      expect(await facade.isEmailVerified(), authRight(true));
    });

    test('sendEmailVerification returns no user when signed out', () async {
      await facade.signOut();

      expect(
        await facade.sendEmailVerification(),
        authSome(const NoSignedInUserException()),
      );
    });

    test('sendEmailVerification completes when a user is signed in', () async {
      expect(await facade.sendEmailVerification(), authNone());
    });

    test('deleteCurrentUser returns no user when signed out', () async {
      await facade.signOut();

      expect(
        await facade.deleteCurrentUser(),
        authSome(const NoSignedInUserException()),
      );
    });

    test('deleteCurrentUser clears the user on success', () async {
      expect(await facade.deleteCurrentUser(), authNone());
      expect(facade.getSignedInUser(), authUserNone());
    });

    test('updatePassword returns no user when signed out', () async {
      await facade.signOut();

      expect(
        await facade.updatePassword(password: validPassword()),
        authSome(const NoSignedInUserException()),
      );
    });

    test('updatePassword succeeds for a signed-in user', () async {
      expect(
        await facade.updatePassword(password: validPassword()),
        authNone(),
      );
    });

    test(
      'reAuthenticateWithPassword returns no user when signed out',
      () async {
        await facade.signOut();

        expect(
          await facade.reAuthenticateWithPassword(password: validPassword()),
          authSome(const NoSignedInUserException()),
        );
      },
    );

    test('idToken returns a token for signed-in users', () async {
      expect((await facade.idToken).isRight(), isTrue);
    });

    test('idToken returns NoSignedInUserException when signed out', () async {
      await facade.signOut();

      expect(
        await facade.idToken,
        authLeft<String>(const NoSignedInUserException()),
      );
    });

    test('authStateChangeStream emits user updates', () async {
      final events = <User?>[];
      final subscription = facade.authStateChangeStream().listen(events.add);

      await facade.signOut();
      await Future<void>.delayed(Duration.zero);
      await subscription.cancel();

      expect(events, isNotEmpty);
    });

    test('isOAuthUser is false for the fake facade', () {
      expect(facade.isOAuthUser, isFalse);
    });

    test('dispose and listener hooks are no-ops', () {
      facade
        ..dispose()
        ..addListener(onSignOut: () {})
        ..removeListener(onSignOut: () {});
    });

    test('unimplemented social entry points throw', () async {
      await expectLater(
        facade.signInWithApple(),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => facade.signInWithFacebook(),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => facade.signInWithGithub(),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => facade.priorSignOutStream(),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => facade.checkActionCode(code: 'code'),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => facade.applyActionCode(code: 'code'),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => facade.sendPasswordResetEmail(emailAddress: 'user@example.com'),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => facade.verifyPasswordResetCode(code: 'code'),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => facade.confirmPasswordReset(
          code: 'code',
          newPassword: 'secret12',
        ),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => facade.setPersistence(persistence: Persistence.LOCAL),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test(
      'signInWithEmailAndPassword returns EmailNotVerifiedException',
      () async {
        final unverifiedFacade = FakeAuthFacade.withUser(
          FakeUser(
            metadata: UserMetadata(0, 0),
            uid: 'uid',
            email: 'user@example.com',
            displayName: 'User',
            photoURL: 'https://example.com/a.png',
            phoneNumber: '123',
            emailVerified: false,
          ),
        );

        final result = await unverifiedFacade.signInWithEmailAndPassword(
          email: validEmail(),
          password: validPassword(),
        );

        expect(result, authSome(const EmailNotVerifiedException()));
      },
    );

    test('signInWithEmailAndPassword maps invalid credentials', () async {
      final reloadFacade = FakeAuthFacade.withUser(_ReloadThrowingFakeUser());

      final result = await reloadFacade.signInWithEmailAndPassword(
        email: validEmail(),
        password: validPassword(),
      );

      expect(
        result,
        authSome(const AuthInvalidEmailAndPasswordCombinationException()),
      );
    });

    test('signInWithEmailAndPassword maps server errors', () async {
      final reloadFacade = FakeAuthFacade.withUser(
        _ReloadThrowingFakeUser(code: 'too-many-requests'),
      );

      final result = await reloadFacade.signInWithEmailAndPassword(
        email: validEmail(),
        password: validPassword(),
      );

      expect(result, authSome(const AuthServerErrorException()));
    });

    test('deleteCurrentUser maps firebase errors', () async {
      final facadeWithThrowingUser = FakeAuthFacade.withUser(
        _DeleteThrowingFakeUser(
          FirebaseAuthException(code: 'requires-recent-login'),
        ),
      );

      expect(
        await facadeWithThrowingUser.deleteCurrentUser(),
        authSome(const RequiresRecentLoginException()),
      );
    });

    test('deleteCurrentUser wraps other firebase errors', () async {
      final facadeWithThrowingUser = FakeAuthFacade.withUser(
        _DeleteThrowingFakeUser(
          FirebaseAuthException(code: 'network-request-failed'),
        ),
      );

      final result = await facadeWithThrowingUser.deleteCurrentUser();

      expect(result.isSome(), isTrue);
      result.fold(
        () => fail('expected some'),
        (ex) => expect(ex, isA<FirebaseAuthRawException>()),
      );
    });

    test('updatePassword maps requires-recent-login', () async {
      final facadeWithThrowingUser = FakeAuthFacade.withUser(
        _PasswordThrowingFakeUser(
          FirebaseAuthException(code: 'requires-recent-login'),
        ),
      );

      expect(
        await facadeWithThrowingUser.updatePassword(password: validPassword()),
        authSome(const RequiresRecentLoginException()),
      );
    });

    test('reAuthenticateWithPassword detects anonymous users', () async {
      final anonymousFacade = FakeAuthFacade.withUser(
        FakeUser(
          metadata: UserMetadata(0, 0),
          uid: 'anon',
          displayName: 'anon',
          photoURL: '',
          phoneNumber: '',
        ),
      );

      expect(
        await anonymousFacade.reAuthenticateWithPassword(
          password: validPassword(),
        ),
        authSome(const UserSignedInUnonymouslyException()),
      );
    });

    test('updatePassword maps firebase errors', () async {
      final facadeWithThrowingUser = FakeAuthFacade.withUser(
        _PasswordThrowingFakeUser(
          FirebaseAuthException(code: 'network-request-failed'),
        ),
      );

      final result = await facadeWithThrowingUser.updatePassword(
        password: validPassword(),
      );

      expect(result.isSome(), isTrue);
      result.fold(
        () => fail('expected some'),
        (ex) => expect(ex, isA<FirebaseAuthRawException>()),
      );
    });

    test(
      'reAuthenticateWithPassword succeeds with a cooperative user',
      () async {
        final facadeWithUser = FakeAuthFacade.withUser(_ReauthFakeUser());

        expect(
          await facadeWithUser.reAuthenticateWithPassword(
            password: validPassword(),
          ),
          authNone(),
        );
      },
    );

    test('reAuthenticateWithPassword maps other firebase errors', () async {
      final facadeWithThrowingUser = FakeAuthFacade.withUser(
        _ReauthThrowingFakeUser(
          FirebaseAuthException(code: 'network-request-failed'),
        ),
      );

      final result = await facadeWithThrowingUser.reAuthenticateWithPassword(
        password: validPassword(),
      );

      expect(result.isSome(), isTrue);
      result.fold(
        () => fail('expected some'),
        (ex) => expect(ex, isA<FirebaseAuthRawException>()),
      );
    });

    test('reAuthenticateWithPassword maps wrong password', () async {
      final facadeWithThrowingUser = FakeAuthFacade.withUser(
        _ReauthThrowingFakeUser(
          FirebaseAuthException(code: 'wrong-password'),
        ),
      );

      final result = await facadeWithThrowingUser.reAuthenticateWithPassword(
        password: validPassword(),
      );

      expect(result, authSome(const InvalidPasswordException()));
    });

    test('idToken wraps FirebaseAuthException', () async {
      final facadeWithThrowingUser = FakeAuthFacade.withUser(
        _TokenThrowingFakeUser(
          FirebaseAuthException(code: 'user-token-expired'),
        ),
      );

      final result = await facadeWithThrowingUser.idToken;

      expect(result.isLeft(), isTrue);
      result.fold(
        (ex) => expect(ex, isA<FirebaseAuthRawException>()),
        (_) => fail('expected left'),
      );
    });
  });

  group('Fake credential helpers', () {
    test('FakeUserCredential toString includes user and credential', () {
      const credential = FakeUserCredential(user: null);

      expect(credential.toString(), contains('FakeUserCredential'));
    });

    test('FakeAdditionalUserInfo toString includes provider data', () {
      const info = FakeAdditionalUserInfo(
        isNewUser: true,
        providerId: 'google',
      );

      expect(info.toString(), contains('FakeAdditionalUserInfo'));
      expect(info.authorizationCode, isNull);
    });

    test('factory helpers build typed credentials', () {
      final google = FakeUserCredentialFactory.google(
        uid: 'uid',
        email: 'user@example.com',
        displayName: 'User',
        photoURL: 'https://example.com/a.png',
        idToken: 'id',
        accessToken: 'access',
      );
      final email = FakeUserCredentialFactory.email(
        user: FakeUser(
          metadata: UserMetadata(0, 0),
          uid: 'uid',
          email: 'user@example.com',
          displayName: 'User',
          photoURL: 'https://example.com/a.png',
          phoneNumber: '123',
        ),
        credential: EmailAuthProvider.credential(
          email: 'user@example.com',
          password: 'secret12',
        ),
      );
      final phone = FakeUserCredentialFactory.phone(
        uid: 'uid',
        phoneNumber: '+10000000000',
        verificationId: 'vid',
        smsCode: '123456',
      );

      expect(
        google.additionalUserInfo?.providerId,
        GoogleAuthProvider.PROVIDER_ID,
      );
      expect(
        email.additionalUserInfo?.providerId,
        EmailAuthProvider.PROVIDER_ID,
      );
      expect(
        phone.additionalUserInfo?.providerId,
        PhoneAuthProvider.PROVIDER_ID,
      );
      expect(fakeGoogleUserCredential.user, isNotNull);
      expect(fakePhoneUserCredential.user, isNotNull);
    });
  });
}

final class _ReloadThrowingFakeUser extends FakeUser {
  _ReloadThrowingFakeUser({this.code = 'user-not-found'})
    : super(
        metadata: UserMetadata(0, 0),
        uid: 'uid',
        email: 'user@example.com',
        displayName: 'User',
        photoURL: 'https://example.com/a.png',
        phoneNumber: '123',
      );

  final String code;

  @override
  Future<void> reload() async {
    throw FirebaseAuthException(code: code);
  }
}

final class _DeleteThrowingFakeUser extends FakeUser {
  _DeleteThrowingFakeUser(this.exception)
    : super(
        metadata: UserMetadata(0, 0),
        uid: 'uid',
        email: 'user@example.com',
        displayName: 'User',
        photoURL: 'https://example.com/a.png',
        phoneNumber: '123',
      );

  final FirebaseAuthException exception;

  @override
  Future<void> delete() async {
    throw exception;
  }
}

final class _PasswordThrowingFakeUser extends FakeUser {
  _PasswordThrowingFakeUser(this.exception)
    : super(
        metadata: UserMetadata(0, 0),
        uid: 'uid',
        email: 'user@example.com',
        displayName: 'User',
        photoURL: 'https://example.com/a.png',
        phoneNumber: '123',
      );

  final FirebaseAuthException exception;

  @override
  Future<void> updatePassword(String newPassword) async {
    throw exception;
  }
}

final class _ReauthFakeUser extends FakeUser {
  _ReauthFakeUser()
    : super(
        metadata: UserMetadata(0, 0),
        uid: 'uid',
        email: 'user@example.com',
        displayName: 'User',
        photoURL: 'https://example.com/a.png',
        phoneNumber: '123',
      );

  @override
  Future<UserCredential> reauthenticateWithCredential(
    AuthCredential credential,
  ) async {
    return FakeUserCredential(user: this, credential: credential);
  }
}

final class _ReauthThrowingFakeUser extends FakeUser {
  _ReauthThrowingFakeUser(this.exception)
    : super(
        metadata: UserMetadata(0, 0),
        uid: 'uid',
        email: 'user@example.com',
        displayName: 'User',
        photoURL: 'https://example.com/a.png',
        phoneNumber: '123',
      );

  final FirebaseAuthException exception;

  @override
  Future<UserCredential> reauthenticateWithCredential(
    AuthCredential credential,
  ) async {
    throw exception;
  }
}

final class _TokenThrowingFakeUser extends FakeUser {
  _TokenThrowingFakeUser(this.exception)
    : super(
        metadata: UserMetadata(0, 0),
        uid: 'uid',
        email: 'user@example.com',
        displayName: 'User',
        photoURL: 'https://example.com/a.png',
        phoneNumber: '123',
      );

  final FirebaseAuthException exception;

  @override
  Future<String> getIdToken([bool forceRefresh = false]) async {
    throw exception;
  }
}
