This package makes use of the firebase authentication API wrapped around Riverpod

## Features

- getSignedInUser
- registerWithEmailAndPassword
- signInWithEmailAndPassword
- signInWithCredential
- signInWithGoogle
- signInWithApple
- signInWithFacebook
- signInWithGithub
- signOut
- isEmailVerified
- sendEmailVerification
- sendPasswordResetEmail
- deleteCurrentUser
- updatePassword
- reAuthenticateWithPassword
- idToken
- authStateChanges
- authChangeListener
- verifyPasswordResetCode
- confirmPasswordReset
- setPersistence
- applyActionCode
- checkActionCode
- priorSignOutListener
- dispose

## Getting started

Assuming you have registered your project and you have already the `firebase_options` in place, 
then initialise the firebase:

```dart
main(){
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
```

## Usage

```dart
...
@override
Widget build(BuildContext context, WidgetRef ref) {
    ref.read(authFacade).signOut();
}
  
```

## Additional information

The current API is:

```dart
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
  Future<Option<AuthenticationEx>> updatePassword({
    required Password password,
  });

  /// Self explained
  Future<Option<AuthenticationEx>> reAuthenticateWithPassword({
    required Password password,
  });

  /// Self explained
  Future<Either<AuthenticationEx, String>> get idToken;

  /// Self explained
  Stream<User?> authStateChanges();

  /// Self explained
  void authChangeListener({
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
  Future<Option<AuthenticationEx>> applyActionCode({
    required String code,
  });

  /// Self explained
  Future<Either<AuthenticationEx, ActionCodeInfo>> checkActionCode({
    required String code,
  });

  Stream<void> priorSignOutListener();

  void dispose();
```


## Translation keys
- auth_canceled_by_user_exception_message_key
- auth_server_error_exception_message_key
- auth_email_already_in_use_exception_message_key
- auth_invalid_email_and_password_combination_exception_message_key
- invalid_password_exception_message_key
- invalid_email_exception_message_key
- sign_out_failed_exception_message_key
- no_signed_in_user_exception_message_key
- is_email_verified_failed_exception_message_key
- reset_password_failed_exception_message_key
- send_email_verification_failed_exception_message_key
- user_email_is_null_auth_exception_message_key
- unknown_auth_exception_message_key
- no_signed_in_user_exception_message_key
- firebase_auth_core_exception_message_key
- user_signed_in_anonymously_exception_message_key
