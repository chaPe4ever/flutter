import 'dart:async';

import 'package:authentication/contracts/auth_facade.dart';
import 'package:authentication/exceptions/auth_exceptions.dart';
import 'package:authentication/utils/firebase_auth_try_catch.dart';
import 'package:authentication/utils/helpers.dart';
import 'package:authentication/utils/value_objects.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' hide generateNonce;

/// Firebase authentication facade implementation
final class FirebaseAuthFacade implements AuthFacade {
  /// Constructor
  FirebaseAuthFacade({
    required FirebaseAuth firebaseAuth,
    required LoggerBase loggerBase,
  }) : _firebaseAuth = firebaseAuth,
       _logger = loggerBase,
       _priorSignOutController =
           StreamController<List<Future<void>>>.broadcast();

  // Fields
  final FirebaseAuth _firebaseAuth;
  final LoggerBase _logger;
  final StreamController<List<Future<void>>> _priorSignOutController;

  // Callback collections
  final Set<Future<void> Function()> _onPreSignOutCallbacks = {};
  final Set<VoidCallback> _onSignOutCallbacks = {};
  final Set<void Function(User user)> _onSignInCallbacks = {};

  // Subscriptions
  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription<void>? _priorSignOutSubscription;

  // Methods
  @override
  Future<Either<AuthenticationEx, UserCredential>>
  registerWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
  }) async {
    final emailAddressStr = email.requireValue;
    final passwordStr = password.requireValue;
    try {
      return right(
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailAddressStr,
          password: passwordStr,
        ),
      );
    } on FirebaseAuthException catch (e, st) {
      _logger.e(e.message ?? '', e: e, st: st);

      if (e.code.contains('email-already-in-use')) {
        return left(const AuthEmailAlreadyInUseException());
      } else {
        return left(const AuthServerErrorException());
      }
    }
  }

  @override
  Future<Either<AuthenticationEx, User?>> signInWithApple({
    String locale = 'en',
  }) async {
    try {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: AppleIDAuthorizationScopes.values,
        nonce: nonce,
      );

      // Validate identityToken
      if (appleCredential.identityToken == null ||
          appleCredential.identityToken!.isEmpty) {
        _logger.e('Apple sign in failed: identityToken is null or empty');
        return left(const AuthServerErrorException());
      }

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final userCredential = await _firebaseAuth.signInWithCredential(
        oauthCredential,
      );
      final user = userCredential.user;

      // Check if this is a new user (first sign-in)
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (user != null) {
        // Apple only provides email/name on FIRST sign-in
        // On subsequent sign-ins, Firebase already has them stored from the first sign-in

        // Update displayName only if:
        // 1. We have name data from Apple (first sign-in)
        // 2. AND Firebase user doesn't have displayName yet
        if ((appleCredential.givenName != null ||
                appleCredential.familyName != null) &&
            user.displayName == null) {
          final displayName =
              '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                  .trim();
          if (displayName.isNotEmpty) {
            await user.updateDisplayName(displayName);
          }
        }

        // Email is automatically stored by Firebase from the first sign-in
        // On subsequent sign-ins, even though Apple doesn't provide email,
        // Firebase user.email will still have the email from the first sign-in
        // (or the private relay email if user chose "Hide My Email")

        // Reload to ensure we have the latest user data
        await user.reload();

        _logger.d(
          'Apple sign-in successful - uid: ${user.uid}, email: ${user.email}, displayName: ${user.displayName}, isNewUser: $isNewUser',
        );
      }

      return right(isNewUser ? _firebaseAuth.currentUser : null);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled ||
          e.code == AuthorizationErrorCode.unknown) {
        return left(const AuthCanceledByUserException());
      }
      _logger.e('Apple sign in failed: ${e.message}', e: e);
      return left(const AuthServerErrorException());
    } on FirebaseAuthException catch (e, st) {
      _logger.e(
        'Firebase auth error: ${e.message ?? ''}, code: ${e.code}',
        e: e,
        st: st,
      );
      if (e.code == 'canceled' || e.code == 'user-cancelled') {
        return left(const AuthCanceledByUserException());
      }
      return left(const AuthServerErrorException());
    }
  }

  @override
  Future<Option<AuthenticationEx>> signInWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
  }) async {
    await _firebaseAuth.currentUser?.reload();

    final emailAddressStr = email.requireValue;
    final passwordStr = password.requireValue;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: emailAddressStr,
        password: passwordStr,
      );
      await _firebaseAuth.currentUser?.reload();
      if (_firebaseAuth.currentUser?.emailVerified == false) {
        return some(const EmailNotVerifiedException());
      }
      return none();
    } on FirebaseAuthException catch (e, st) {
      if (e.code.contains('user-not-found') ||
          e.code.contains('wrong-password') ||
          e.code.contains('invalid-credential') ||
          e.code.contains('INVALID_LOGIN_CREDENTIALS')) {
        return some(const AuthInvalidEmailAndPasswordCombinationException());
      } else {
        _logger.e(e.message ?? '', e: e, st: st);

        return some(const AuthServerErrorException());
      }
    }
  }

  @override
  Future<Option<AuthenticationEx>> signInWithFacebook() {
    // TODO(Petros): implement signInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<Option<AuthenticationEx>> signInWithGithub() {
    // TODO(Petros): implement signInWithGithub
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthenticationEx, UserCredential>> signInWithCredential({
    required AuthCredential authCredential,
  }) => futureEitherAuthTryCatch(
    () => _firebaseAuth.signInWithCredential(authCredential),
    logger: _logger,
    customException: const IsEmailVerifiedFailedException(),
  );

  @override
  Future<Either<AuthenticationEx, User?>> signInWithGoogle({
    String locale = 'en',
  }) async {
    try {
      final googleProvider = GoogleAuthProvider()
        //  tells Google’s OAuth to show the account selection screen every time
        // instead of auto-signing with the last account.
        ..setCustomParameters({'prompt': 'select_account', 'locale': locale});

      final userCredential = await _firebaseAuth.signInWithProvider(
        googleProvider,
      );

      // Check if this is a new user (first sign-in)
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      await _firebaseAuth.currentUser?.reload();

      return right(isNewUser ? _firebaseAuth.currentUser : null);
    } on FirebaseAuthException catch (e, st) {
      _logger.e(e.message ?? '', e: e, st: st);
      if (e.code == 'web-context-canceled' ||
          e.code == 'web-context-cancelled' ||
          e.code == 'popup-closed-by-user') {
        return left(const AuthCanceledByUserException());
      }

      return left(const AuthServerErrorException());
    }
  }

  @override
  Option<User> getSignedInUser() => optionOf(_firebaseAuth.currentUser);

  @override
  Future<Option<AuthenticationEx>> signOut() async => futureOptionAuthTryCatch(
    () async {
      // Collect futures from all pre-signout callbacks
      final preSignOutFutures = _onPreSignOutCallbacks.map((callback) {
        // Wrap each in try-catch so individual failures don't block signout
        return callback().catchError((Object e) {
          _logger.e('Pre-signout callback failed', e: e);
          // Return completed future so Future.wait doesn't fail
          return Future<void>.value();
        });
      }).toList();

      // Notify listeners with the futures for optional tracking
      _priorSignOutController.add(preSignOutFutures);

      // Wait for all pre-signout operations to complete
      await Future.wait(preSignOutFutures);

      // Now proceed with the actual sign out
      await _firebaseAuth.signOut();
      await _firebaseAuth.currentUser?.reload();
    },
    logger: _logger,
    customException: const SignOutFailedException(),
  );

  @override
  Future<Either<AuthenticationEx, bool>> isEmailVerified() async =>
      futureEitherAuthTryCatch(
        () async {
          final currentUser = _firebaseAuth.currentUser;
          if (currentUser == null) {
            // Means there is no logged in user
            throw const NoSignedInUserException();
          }
          await currentUser.reload();
          return currentUser.emailVerified;
        },
        logger: _logger,
        customException: const IsEmailVerifiedFailedException(),
      );

  @override
  Future<Option<AuthenticationEx>> sendEmailVerification({
    ActionCodeSettings? actionCodeSettings,
  }) async => futureOptionAuthTryCatch(
    () async {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        // Means there is no logged in user
        throw const NoSignedInUserException();
      }

      await currentUser.sendEmailVerification(actionCodeSettings);
    },
    logger: _logger,
    customException: const SendEmailVerificationFailedException(),
  );

  @override
  Future<Either<AuthenticationEx, ActionCodeInfo>> checkActionCode({
    required String code,
  }) async => futureEitherAuthTryCatch(
    () async => _firebaseAuth.checkActionCode(code),
    logger: _logger,
  );

  @override
  Future<Option<AuthenticationEx>> applyActionCode({
    required String code,
  }) async => futureOptionAuthTryCatch(
    () async => _firebaseAuth.applyActionCode(code),
    logger: _logger,
  );

  @override
  Future<Option<AuthenticationEx>> sendPasswordResetEmail({
    required String emailAddress,
    ActionCodeSettings? actionCodeSettings,
  }) async => futureOptionAuthTryCatch(
    () async => _firebaseAuth.sendPasswordResetEmail(
      email: emailAddress,
      actionCodeSettings: actionCodeSettings,
    ),
    logger: _logger,
    customException: const ResetPasswordFailedException(),
  );

  @override
  Future<Either<AuthenticationEx, String>> verifyPasswordResetCode({
    required String code,
  }) async => futureEitherAuthTryCatch(
    () async => _firebaseAuth.verifyPasswordResetCode(code),
    logger: _logger,
  );

  @override
  Future<Option<AuthenticationEx>> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async => futureOptionAuthTryCatch(
    () async => _firebaseAuth.confirmPasswordReset(
      code: code,
      newPassword: newPassword,
    ),
    logger: _logger,
  );

  @override
  Future<Option<AuthenticationEx>> setPersistence({
    required Persistence persistence,
  }) async => futureOptionAuthTryCatch(
    () async => _firebaseAuth.setPersistence(persistence),
    logger: _logger,
  );

  @override
  Future<Option<AuthenticationEx>> deleteCurrentUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        // Means there is no logged in user

        return some(const NoSignedInUserException());
      }
      await currentUser.delete();
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
      final currentUser = _firebaseAuth.currentUser;

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
      final currentUser = _firebaseAuth.currentUser;

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
      final idToken = await _firebaseAuth.currentUser?.getIdToken();

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
  Stream<User?> authStateChangeStream() => _firebaseAuth.authStateChanges();

  @override
  void addListener({
    Future<void> Function()? onPreSignOut,
    VoidCallback? onSignOut,
    void Function(User user)? onSignIn,
  }) {
    assert(
      onPreSignOut != null || onSignOut != null || onSignIn != null,
      'At least one of onPreSignOut, onSignOut, or onSignIn must be provided',
    );

    // Add callbacks to appropriate sets
    if (onPreSignOut != null) _onPreSignOutCallbacks.add(onPreSignOut);
    if (onSignOut != null) _onSignOutCallbacks.add(onSignOut);
    if (onSignIn != null) _onSignInCallbacks.add(onSignIn);

    // Initialize the auth state subscription if it doesn't exist
    _authStateSubscription ??= _firebaseAuth.authStateChanges().listen((
      User? user,
    ) {
      if (user == null) {
        // Create a defensive copy to avoid concurrent modification
        final callbacksCopy = Set<VoidCallback>.from(_onSignOutCallbacks);
        for (final callback in callbacksCopy) {
          // Check if the callback is still in the original set before calling
          if (_onSignOutCallbacks.contains(callback)) {
            callback();
          }
        }
      } else {
        // Create a defensive copy to avoid concurrent modification
        final callbacksCopy = Set<void Function(User)>.from(_onSignInCallbacks);
        for (final callback in callbacksCopy) {
          // Check if the callback is still in the original set before calling
          if (_onSignInCallbacks.contains(callback)) {
            callback(user);
          }
        }
      }
    });

    // Initialize the prior sign out subscription if it doesn't exist
    _priorSignOutSubscription ??= _priorSignOutController.stream.listen((_) {
      // Stream now receives the list of futures, but we don't need to do anything
      // with them here since they're already being awaited in the signOut method
    });
  }

  @override
  void removeListener({
    Future<void> Function()? onPreSignOut,
    VoidCallback? onSignOut,
    void Function(User user)? onSignIn,
  }) {
    if (onPreSignOut != null) _onPreSignOutCallbacks.remove(onPreSignOut);
    if (onSignOut != null) _onSignOutCallbacks.remove(onSignOut);
    if (onSignIn != null) _onSignInCallbacks.remove(onSignIn);

    // Cancel subscriptions if no more callbacks
    if (_onPreSignOutCallbacks.isEmpty &&
        _onSignOutCallbacks.isEmpty &&
        _onSignInCallbacks.isEmpty) {
      _authStateSubscription?.cancel();
      _authStateSubscription = null;
      _priorSignOutSubscription?.cancel();
      _priorSignOutSubscription = null;
    }
  }

  @override
  Stream<List<Future<void>>> priorSignOutStream() =>
      _priorSignOutController.stream;

  @override
  void dispose() {
    // Cancel all subscriptions
    _authStateSubscription?.cancel();
    _priorSignOutSubscription?.cancel();

    // Clear all callbacks
    _onPreSignOutCallbacks.clear();
    _onSignOutCallbacks.clear();
    _onSignInCallbacks.clear();

    // Close stream controller
    _priorSignOutController.close();
  }
}
