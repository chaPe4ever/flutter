import 'package:authentication/exceptions/auth_exceptions.dart';
import 'package:core/core.dart';

final _emailRegExp = RegExp(
  r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9][a-zA-Z0-9-]{0,253}\.)*[a-zA-Z0-9][a-zA-Z0-9-]{0,253}\.[a-zA-Z0-9]{2,}$",
);

// Valid password rules:
//  8 to 20 characters
//  Must contain at least one digit
//  Must contain at least one capital letter
//  Must contain one of the following characters:!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?
// final _passwordRegExp = RegExp(
//   r'''^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,20}$''',
// );

///
Either<CoreException, String> validateEmailAddress(String? input) {
  // Maybe not the most robust way of email validation but it's good enough
  if (!isXSS(input) && input != null && _emailRegExp.hasMatch(input)) {
    return right(input);
  } else {
    return left(const InvalidEmailException());
  }
}

///
Either<CoreException, String> validatePassword(String? input) {
  if (!isXSS(input) && input != null && input.length >= 6) {
    return right(input);
  } else {
    return left(const InvalidPasswordException());
  }
}
