import 'package:authentication/constants/authentication_constants.dart';
import 'package:authentication/constants/trans_keys_constants.dart';
import 'package:authentication/exceptions/auth_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationEx defaults', () {
    final cases = <AuthenticationEx>[
      const AuthCanceledByUserException(),
      const AuthServerErrorException(),
      const AuthEmailAlreadyInUseException(),
      const AuthInvalidEmailAndPasswordCombinationException(),
      const InvalidPasswordException(),
      const InvalidEmailException(),
      const SignOutFailedException(),
      const NoSignedInUserException(),
      const IsEmailVerifiedFailedException(),
      const ResetPasswordFailedException(),
      const SendEmailVerificationFailedException(),
      const UserEmailIsNullAuthException(),
      const UnknownAuthException(),
      const RequiresRecentLoginException(),
      const FirebaseAuthRawException(),
      const UserSignedInUnonymouslyException(),
      const EmailNotVerifiedException(),
    ];

    test('uses the authentication package prefix in toString', () {
      for (final exception in cases) {
        expect(
          exception.toString(),
          startsWith('$kAuthenticationPkgName : '),
        );
      }
    });

    test('EmailNotVerifiedException uses the generated trans key', () {
      expect(
        const EmailNotVerifiedException().messageKey,
        TransKeys.emailNotVerified,
      );
    });

    test('includes inner details when present', () {
      expect(
        const FirebaseAuthRawException(
          innerMessage: 'network',
          innerError: 'socket',
          innerCode: 'network-request-failed',
        ).toString(),
        contains('network'),
      );
    });
  });
}
