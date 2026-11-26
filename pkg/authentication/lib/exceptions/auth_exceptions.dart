import 'package:authentication/constants/authentication_constants.dart';
import 'package:authentication/constants/trans_keys_constants.dart';
import 'package:core/core.dart';

sealed class AuthenticationEx extends CoreException {
  const new({
    required super.messageKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix = kAuthenticationPkgName,
  });
}

///
final class AuthCanceledByUserException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'auth_canceled_by_user_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

///
final class AuthServerErrorException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'auth_server_error_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

///
final class AuthEmailAlreadyInUseException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'auth_email_already_in_use_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

///
final class AuthInvalidEmailAndPasswordCombinationException
    extends AuthenticationEx {
  ///
  const new({
    super.messageKey =
        'auth_invalid_email_and_password_combination_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

///
final class InvalidPasswordException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'invalid_password_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

///
final class InvalidEmailException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'invalid_email_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

final class SignOutFailedException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'sign_out_failed_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

final class NoSignedInUserException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'no_signed_in_user_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

final class IsEmailVerifiedFailedException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'is_email_verified_failed_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

final class ResetPasswordFailedException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'reset_password_failed_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

final class SendEmailVerificationFailedException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'send_email_verification_failed_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

final class UserEmailIsNullAuthException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'user_email_is_null_auth_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

final class UnknownAuthException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'unknown_auth_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

final class RequiresRecentLoginException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'no_signed_in_user_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

final class FirebaseAuthRawException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'firebase_auth_core_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

final class UserSignedInUnonymouslyException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = 'user_signed_in_anonymously_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

final class EmailNotVerifiedException extends AuthenticationEx {
  ///
  const new({
    super.messageKey = TransKeys.emailNotVerified,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}
