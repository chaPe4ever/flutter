import 'dart:async';

import 'package:authentication/contracts/auth_facade.dart';
import 'package:authentication/exceptions/auth_exceptions.dart';
import 'package:authentication/utils/firebase_auth_try_catch.dart';
import 'package:authentication/utils/value_objects.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Firebase authentication facade implementation
final class FirebaseAuthFacade implements AuthFacade {
  /// Constructor
  FirebaseAuthFacade({
    required FirebaseAuth firebaseAuth,
    required LoggerBase loggerBase,
  }) : _firebaseAuth = firebaseAuth,
       _logger = loggerBase,
       _priorSignOutController = StreamController<void>.broadcast();

  // Fields
  final FirebaseAuth _firebaseAuth;
  final LoggerBase _logger;
  final StreamController<void> _priorSignOutController;

  // Callback collections
  final Set<VoidCallback> _onPreSignOutCallbacks = {};
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
  Future<Option<AuthenticationEx>> signInWithApple() async {
    // TODO(Petros): implement signInWithApple
    throw UnimplementedError();
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
  Future<Option<AuthenticationEx>> signInWithGoogle() async {
    try {
      // final googleUser = await _googleSignIn.signIn();
      // if (googleUser == null) {
      //   return some(const AuthCanceledByUserException());
      // }

      // final googleAuthentication = await googleUser.authentication;

      // final authCredential = GoogleAuthProvider.credential(
      //   idToken: googleAuthentication.idToken,
      //   accessToken: googleAuthentication.accessToken,
      // );

      // await _firebaseAuth.signInWithCredential(authCredential);
      return none();
    } on FirebaseAuthException catch (e, st) {
      _logger.e(e.message ?? '', e: e, st: st);

      return some(const AuthServerErrorException());
    }
  }

  @override
  Option<User> getSignedInUser() => optionOf(_firebaseAuth.currentUser);

  @override
  Future<Option<AuthenticationEx>> signOut() async => futureOptionAuthTryCatch(
    () async {
      _priorSignOutController.add(null);

      // googleSignIn.signOut();
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
    VoidCallback? onPreSignOut,
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
        for (final callback in _onSignOutCallbacks) {
          callback();
        }
      } else {
        for (final callback in _onSignInCallbacks) {
          callback(user);
        }
      }
    });

    // Initialize the prior sign out subscription if it doesn't exist
    _priorSignOutSubscription ??= _priorSignOutController.stream.listen((_) {
      for (final callback in _onPreSignOutCallbacks) {
        callback();
      }
    });
  }

  @override
  void removeListener({
    VoidCallback? onPreSignOut,
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
  Stream<void> priorSignOutStream() => _priorSignOutController.stream;

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
