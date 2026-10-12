import 'dart:async';

import 'package:authentication/exceptions/auth_exceptions.dart';
import 'package:authentication/implementations/firebase_auth_facade.dart';
import 'package:authentication/utils/value_objects.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/auth_dartz.dart';
import '../helpers/auth_mocks.dart';
import '../helpers/fake_logger.dart';

void main() {
  setUpAll(registerAuthFallbacks);

  late MockFirebaseAuth firebaseAuth;
  late MockUser user;
  late MockUserCredential userCredential;
  late FakeLogger logger;
  late FirebaseAuthFacade facade;

  EmailAddress validEmail() => EmailAddress('user@example.com');
  Password validPassword() => Password('secret12');

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    user = MockUser();
    userCredential = MockUserCredential();
    logger = FakeLogger();
    facade = FirebaseAuthFacade(
      firebaseAuth: firebaseAuth,
      loggerBase: logger,
    );

    when(() => user.uid).thenReturn('uid-1');
    when(() => user.email).thenReturn('user@example.com');
    when(() => user.displayName).thenReturn('User');
    when(() => user.emailVerified).thenReturn(true);
    when(() => user.providerData).thenReturn([]);
    when(() => user.reload()).thenAnswer((_) async {});
    when(() => user.delete()).thenAnswer((_) async {});
    when(() => user.updatePassword(any())).thenAnswer((_) async {});
    when(() => user.getIdToken()).thenAnswer((_) async => 'token');
    when(() => user.sendEmailVerification(any())).thenAnswer((_) async {});
    when(() => user.reauthenticateWithCredential(any())).thenAnswer(
      (_) async => userCredential,
    );
    when(() => user.updateDisplayName(any())).thenAnswer((_) async {});

    when(() => userCredential.user).thenReturn(user);
    when(() => userCredential.additionalUserInfo).thenReturn(null);

    when(() => firebaseAuth.currentUser).thenReturn(user);
    when(() => firebaseAuth.authStateChanges()).thenAnswer(
      (_) => const Stream<User?>.empty(),
    );
    when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
  });

  group('registerWithEmailAndPassword', () {
    test('returns credential on success', () async {
      when(
        () => firebaseAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => userCredential);

      final result = await facade.registerWithEmailAndPassword(
        email: validEmail(),
        password: validPassword(),
      );

      expect(result, authRight(userCredential));
    });

    test(
      'maps email-already-in-use to AuthEmailAlreadyInUseException',
      () async {
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

        final result = await facade.registerWithEmailAndPassword(
          email: validEmail(),
          password: validPassword(),
        );

        expect(
          result,
          authLeft<UserCredential>(const AuthEmailAlreadyInUseException()),
        );
      },
    );

    test('maps other Firebase errors to AuthServerErrorException', () async {
      when(
        () => firebaseAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));

      final result = await facade.registerWithEmailAndPassword(
        email: validEmail(),
        password: validPassword(),
      );

      expect(
        result,
        authLeft<UserCredential>(const AuthServerErrorException()),
      );
      expect(logger.errorMessages, isNotEmpty);
    });
  });

  group('signInWithEmailAndPassword', () {
    test('returns none when sign-in succeeds and email is verified', () async {
      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => userCredential);

      final result = await facade.signInWithEmailAndPassword(
        email: validEmail(),
        password: validPassword(),
      );

      expect(result, authNone());
    });

    test(
      'returns EmailNotVerifiedException when email is not verified',
      () async {
        when(() => user.emailVerified).thenReturn(false);
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        final result = await facade.signInWithEmailAndPassword(
          email: validEmail(),
          password: validPassword(),
        );

        expect(result, authSome(const EmailNotVerifiedException()));
      },
    );

    test(
      'maps invalid credential codes to '
      'AuthInvalidEmailAndPasswordCombinationException',
      () async {
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

        final result = await facade.signInWithEmailAndPassword(
          email: validEmail(),
          password: validPassword(),
        );

        expect(
          result,
          authSome(const AuthInvalidEmailAndPasswordCombinationException()),
        );
      },
    );

    test('maps unknown Firebase errors to AuthServerErrorException', () async {
      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(FirebaseAuthException(code: 'too-many-requests'));

      final result = await facade.signInWithEmailAndPassword(
        email: validEmail(),
        password: validPassword(),
      );

      expect(result, authSome(const AuthServerErrorException()));
    });
  });

  group('signInWithCredential', () {
    test('returns credential on success', () async {
      final authCredential = EmailAuthProvider.credential(
        email: 'user@example.com',
        password: 'secret12',
      );
      when(
        () => firebaseAuth.signInWithCredential(authCredential),
      ).thenAnswer((_) async => userCredential);

      final result = await facade.signInWithCredential(
        authCredential: authCredential,
      );

      expect(result, authRight(userCredential));
    });
  });

  group('signInWithGoogle', () {
    test('returns current user for new google users', () async {
      final additional = MockAdditionalUserInfo();
      when(() => additional.isNewUser).thenReturn(true);
      when(() => userCredential.additionalUserInfo).thenReturn(additional);
      when(
        () => firebaseAuth.signInWithProvider(any()),
      ).thenAnswer((_) async => userCredential);

      final result = await facade.signInWithGoogle(locale: 'de');

      expect(result, authRight(user));
    });

    test('returns null for returning google users', () async {
      when(
        () => firebaseAuth.signInWithProvider(any()),
      ).thenAnswer((_) async => userCredential);

      final result = await facade.signInWithGoogle();

      expect(result, authRight<User?>(null));
    });

    test('maps popup cancellation to AuthCanceledByUserException', () async {
      when(() => firebaseAuth.signInWithProvider(any())).thenThrow(
        FirebaseAuthException(code: 'popup-closed-by-user'),
      );

      final result = await facade.signInWithGoogle();

      expect(result, authLeft<User?>(const AuthCanceledByUserException()));
    });

    test('maps other google errors to AuthServerErrorException', () async {
      when(() => firebaseAuth.signInWithProvider(any())).thenThrow(
        FirebaseAuthException(code: 'account-exists-with-different-credential'),
      );

      final result = await facade.signInWithGoogle();

      expect(
        result,
        authLeft<User?>(const AuthServerErrorException()),
      );
    });
  });

  group('signOut', () {
    test('runs pre-signout callbacks and signs out', () async {
      var preSignOutCalled = false;
      facade.addListener(
        onPreSignOut: () async {
          preSignOutCalled = true;
        },
      );

      final result = await facade.signOut();

      expect(result, authNone());
      expect(preSignOutCalled, isTrue);
      verify(() => firebaseAuth.signOut()).called(1);
    });

    test(
      'logs pre-signout callback failures without aborting sign out',
      () async {
        facade.addListener(
          onPreSignOut: () async {
            throw StateError('pre-signout failed');
          },
        );

        final result = await facade.signOut();

        expect(result, authNone());
        expect(
          logger.errorMessages.any(
            (message) => message.contains('Pre-signout'),
          ),
          isTrue,
        );
      },
    );
  });

  group('email verification helpers', () {
    test('isEmailVerified throws when no user is signed in', () async {
      when(() => firebaseAuth.currentUser).thenReturn(null);

      final result = await facade.isEmailVerified();

      expect(result, authLeft<bool>(const NoSignedInUserException()));
    });

    test('isEmailVerified returns the flag after reload', () async {
      when(() => user.emailVerified).thenReturn(false);

      final result = await facade.isEmailVerified();

      expect(result, authRight(false));
      verify(() => user.reload()).called(1);
    });

    test('sendEmailVerification returns no user when signed out', () async {
      when(() => firebaseAuth.currentUser).thenReturn(null);

      final result = await facade.sendEmailVerification();

      expect(result, authSome(const NoSignedInUserException()));
    });

    test('sendEmailVerification sends the email for signed-in users', () async {
      final result = await facade.sendEmailVerification();

      expect(result, authNone());
      verify(() => user.sendEmailVerification()).called(1);
    });
  });

  group('password reset and action codes', () {
    test('checkActionCode returns action code info', () async {
      final info = MockActionCodeInfo();
      when(
        () => firebaseAuth.checkActionCode('code'),
      ).thenAnswer((_) async => info);

      final result = await facade.checkActionCode(code: 'code');

      expect(result, authRight(info));
    });

    test('applyActionCode completes on success', () async {
      when(() => firebaseAuth.applyActionCode('code')).thenAnswer((_) async {});

      expect(await facade.applyActionCode(code: 'code'), authNone());
    });

    test('sendPasswordResetEmail completes on success', () async {
      when(
        () => firebaseAuth.sendPasswordResetEmail(
          email: any(named: 'email'),
          actionCodeSettings: any(named: 'actionCodeSettings'),
        ),
      ).thenAnswer((_) async {});

      expect(
        await facade.sendPasswordResetEmail(emailAddress: 'user@example.com'),
        authNone(),
      );
    });

    test('verifyPasswordResetCode returns the email', () async {
      when(
        () => firebaseAuth.verifyPasswordResetCode('code'),
      ).thenAnswer((_) async => 'user@example.com');

      expect(
        await facade.verifyPasswordResetCode(code: 'code'),
        authRight('user@example.com'),
      );
    });

    test('confirmPasswordReset completes on success', () async {
      when(
        () => firebaseAuth.confirmPasswordReset(
          code: any(named: 'code'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async {});

      expect(
        await facade.confirmPasswordReset(
          code: 'code',
          newPassword: 'secret12',
        ),
        authNone(),
      );
    });

    test('setPersistence completes on success', () async {
      when(
        () => firebaseAuth.setPersistence(Persistence.LOCAL),
      ).thenAnswer((_) async {});

      expect(
        await facade.setPersistence(persistence: Persistence.LOCAL),
        authNone(),
      );
    });
  });

  group('account maintenance', () {
    test('deleteCurrentUser returns no user when signed out', () async {
      when(() => firebaseAuth.currentUser).thenReturn(null);

      expect(
        await facade.deleteCurrentUser(),
        authSome(const NoSignedInUserException()),
      );
    });

    test('deleteCurrentUser succeeds for signed-in users', () async {
      expect(await facade.deleteCurrentUser(), authNone());
      verify(() => user.delete()).called(1);
    });

    test('deleteCurrentUser maps requires-recent-login', () async {
      when(() => user.delete()).thenThrow(
        FirebaseAuthException(code: 'requires-recent-login'),
      );

      expect(
        await facade.deleteCurrentUser(),
        authSome(const RequiresRecentLoginException()),
      );
    });

    test(
      'deleteCurrentUser wraps other FirebaseAuthException errors',
      () async {
        when(() => user.delete()).thenThrow(
          FirebaseAuthException(code: 'network-request-failed'),
        );

        final result = await facade.deleteCurrentUser();

        expect(result.isSome(), isTrue);
        result.fold(
          () => fail('expected some'),
          (ex) => expect(ex, isA<FirebaseAuthRawException>()),
        );
      },
    );

    test('updatePassword returns no user when signed out', () async {
      when(() => firebaseAuth.currentUser).thenReturn(null);

      expect(
        await facade.updatePassword(password: validPassword()),
        authSome(const NoSignedInUserException()),
      );
    });

    test('updatePassword succeeds for signed-in users', () async {
      expect(
        await facade.updatePassword(password: validPassword()),
        authNone(),
      );
      verify(() => user.updatePassword('secret12')).called(1);
    });

    test('updatePassword maps requires-recent-login', () async {
      when(() => user.updatePassword(any())).thenThrow(
        FirebaseAuthException(code: 'requires-recent-login'),
      );

      expect(
        await facade.updatePassword(password: validPassword()),
        authSome(const RequiresRecentLoginException()),
      );
    });

    test('updatePassword wraps other FirebaseAuthException errors', () async {
      when(() => user.updatePassword(any())).thenThrow(
        FirebaseAuthException(code: 'network-request-failed'),
      );

      final result = await facade.updatePassword(password: validPassword());

      expect(result.isSome(), isTrue);
      result.fold(
        () => fail('expected some'),
        (ex) => expect(ex, isA<FirebaseAuthRawException>()),
      );
    });

    test(
      'reAuthenticateWithPassword returns no user when signed out',
      () async {
        when(() => firebaseAuth.currentUser).thenReturn(null);

        expect(
          await facade.reAuthenticateWithPassword(password: validPassword()),
          authSome(const NoSignedInUserException()),
        );
      },
    );

    test('reAuthenticateWithPassword detects anonymous users', () async {
      when(() => user.email).thenReturn(null);

      expect(
        await facade.reAuthenticateWithPassword(password: validPassword()),
        authSome(const UserSignedInUnonymouslyException()),
      );
    });

    test('reAuthenticateWithPassword maps wrong-password', () async {
      when(() => user.reauthenticateWithCredential(any())).thenThrow(
        FirebaseAuthException(code: 'wrong-password'),
      );

      expect(
        await facade.reAuthenticateWithPassword(password: validPassword()),
        authSome(const InvalidPasswordException()),
      );
    });

    test('reAuthenticateWithPassword succeeds', () async {
      expect(
        await facade.reAuthenticateWithPassword(password: validPassword()),
        authNone(),
      );
    });

    test(
      'reAuthenticateWithPassword wraps other FirebaseAuthException errors',
      () async {
        when(() => user.reauthenticateWithCredential(any())).thenThrow(
          FirebaseAuthException(code: 'network-request-failed'),
        );

        final result = await facade.reAuthenticateWithPassword(
          password: validPassword(),
        );

        expect(result.isSome(), isTrue);
        result.fold(
          () => fail('expected some'),
          (ex) => expect(ex, isA<FirebaseAuthRawException>()),
        );
      },
    );
  });

  group('idToken', () {
    test('returns the token for signed-in users', () async {
      expect(await facade.idToken, authRight('token'));
    });

    test(
      'returns NoSignedInUserException when there is no current user',
      () async {
        when(() => firebaseAuth.currentUser).thenReturn(null);

        final result = await facade.idToken;

        expect(result, authLeft<bool>(const NoSignedInUserException()));
      },
    );

    test('wraps FirebaseAuthException from getIdToken', () async {
      when(() => user.getIdToken()).thenThrow(
        FirebaseAuthException(code: 'user-token-expired'),
      );

      final result = await facade.idToken;

      expect(result.isLeft(), isTrue);
      result.fold(
        (ex) => expect(ex, isA<FirebaseAuthRawException>()),
        (_) => fail('expected left'),
      );
    });
  });

  group('listeners and lifecycle', () {
    test('notifies sign-in and sign-out listeners', () async {
      var signedIn = false;
      var signedOut = false;
      final controller = StreamController<User?>();

      when(() => firebaseAuth.authStateChanges()).thenAnswer(
        (_) => controller.stream,
      );

      facade.addListener(
        onSignIn: (_) => signedIn = true,
        onSignOut: () => signedOut = true,
      );

      controller.add(user);
      await Future<void>.delayed(Duration.zero);
      controller.add(null);
      await Future<void>.delayed(Duration.zero);

      expect(signedIn, isTrue);
      expect(signedOut, isTrue);

      await controller.close();
    });

    test('removeListener cancels auth subscriptions when empty', () async {
      final controller = StreamController<User?>();
      when(() => firebaseAuth.authStateChanges()).thenAnswer(
        (_) => controller.stream,
      );

      Future<void> onPreSignOut() async {}
      void onSignOut() {}
      void onSignIn(User _) {}

      facade
        ..addListener(
          onPreSignOut: onPreSignOut,
          onSignOut: onSignOut,
          onSignIn: onSignIn,
        )
        ..removeListener(
          onPreSignOut: onPreSignOut,
          onSignOut: onSignOut,
          onSignIn: onSignIn,
        )
        ..dispose();

      await controller.close();
    });

    test('priorSignOutStream emits callback futures', () async {
      final events = <List<Future<void>>>[];
      final subscription = facade.priorSignOutStream().listen(events.add);

      facade.addListener(
        onPreSignOut: () async {},
      );
      await facade.signOut();
      await Future<void>.delayed(Duration.zero);

      expect(events, isNotEmpty);
      await subscription.cancel();
    });

    test('getSignedInUser exposes the current firebase user', () {
      expect(facade.getSignedInUser(), authUserSome(user));
    });

    test('authStateChangeStream forwards firebase auth state changes', () {
      final stream = facade.authStateChangeStream();

      verify(() => firebaseAuth.authStateChanges()).called(1);
      expect(stream, isA<Stream<User?>>());
    });

    test('isOAuthUser is false without a user', () {
      when(() => firebaseAuth.currentUser).thenReturn(null);

      expect(facade.isOAuthUser, isFalse);
    });

    test('isOAuthUser is false for password-only accounts', () {
      final provider = MockUserInfo();
      when(() => provider.providerId).thenReturn('password');
      when(() => user.providerData).thenReturn([provider]);

      expect(facade.isOAuthUser, isFalse);
    });

    test('isOAuthUser is true when a non-password provider exists', () {
      final provider = MockUserInfo();
      when(
        () => provider.providerId,
      ).thenReturn(GoogleAuthProvider.PROVIDER_ID);
      when(() => user.providerData).thenReturn([provider]);

      expect(facade.isOAuthUser, isTrue);
    });
  });

  group('unimplemented providers', () {
    test('facebook and github sign-in throw UnimplementedError', () {
      expect(
        () => facade.signInWithFacebook(),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => facade.signInWithGithub(),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
