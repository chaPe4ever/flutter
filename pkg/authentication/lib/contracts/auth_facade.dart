import 'package:authentication/exceptions/auth_exceptions.dart';
import 'package:authentication/utils/value_objects.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Authentication facade interface
abstract interface class AuthFacade {
  /// Get the signed in firebase user
  Option<User> getSignedInUser();

  /// Register user with his email and password
  Future<Either<AuthenticationEx, UserCredential>>
  registerWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
  });

  /// Sign in user with his email and password
  Future<Option<AuthenticationEx>> signInWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
  });

  /// Self explained
  Future<Either<AuthenticationEx, UserCredential>> signInWithCredential({
    required AuthCredential authCredential,
  });

  /// Sign in user using his google account
  Future<Option<AuthenticationEx>> signInWithGoogle();

  /// Sign in user using his apple account
  Future<Option<AuthenticationEx>> signInWithApple();

  /// Sign in user using his facebook account
  Future<Option<AuthenticationEx>> signInWithFacebook();

  /// Sign in user using his github account
  Future<Option<AuthenticationEx>> signInWithGithub();

  /// sign out user
  Future<Option<AuthenticationEx>> signOut();

  /// Self explained
  Future<Either<AuthenticationEx, bool>> isEmailVerified();

  /// Self explained
  Future<Option<AuthenticationEx>> sendEmailVerification({
    ActionCodeSettings? actionCodeSettings,
  });

  /// Self explained
  Future<Option<AuthenticationEx>> sendPasswordResetEmail({
    required String emailAddress,
    ActionCodeSettings? actionCodeSettings,
  });

  /// Self explained
  Future<Option<AuthenticationEx>> deleteCurrentUser();

  /// Self explained
  Future<Option<AuthenticationEx>> updatePassword({required Password password});

  /// Self explained
  Future<Option<AuthenticationEx>> reAuthenticateWithPassword({
    required Password password,
  });

  /// Self explained
  Future<Either<AuthenticationEx, String>> get idToken;

  /// Self explained
  Stream<User?> authStateChangeStream();

  /// Self explained
  void removeListener({
    Future<void> Function()? onPreSignOut,
    VoidCallback? onSignOut,
    void Function(User user)? onSignIn,
  });
  void addListener({
    Future<void> Function()? onPreSignOut,
    VoidCallback? onSignOut,
    void Function(User user)? onSignIn,
  });

  /// Self explained
  Future<Either<AuthenticationEx, String>> verifyPasswordResetCode({
    required String code,
  });

  /// Self explained
  Future<Option<AuthenticationEx>> confirmPasswordReset({
    required String code,
    required String newPassword,
  });

  /// Self explained
  Future<Option<AuthenticationEx>> setPersistence({
    required Persistence persistence,
  });

  /// Self explained
  Future<Option<AuthenticationEx>> applyActionCode({required String code});

  /// Self explained
  Future<Either<AuthenticationEx, ActionCodeInfo>> checkActionCode({
    required String code,
  });

  Stream<void> priorSignOutStream();

  void dispose();
}
