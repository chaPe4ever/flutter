import 'package:authentication/utils/validators.dart';
import 'package:core/core.dart';

///
final class EmailAddress extends ValueObject<String> {
  /// Ctr
  factory EmailAddress(String? input) {
    return EmailAddress._(validateEmailAddress(input));
  }

  const EmailAddress._(this.value);

  /// Used on textField validator as as a tear-off
  @override
  String? validator(String? value) {
    return EmailAddress._(
      validateEmailAddress(value),
    ).value.fold((l) => l.messageKey, (r) => null);
  }

  @override
  final Either<CoreException, String> value;
}

///
final class Password extends ValueObject<String> {
  ///
  factory Password(String? value) {
    return Password._(validatePassword(value));
  }

  const Password._(this.value);

  @override
  String? validator(String? value) {
    return Password._(
      validatePassword(value),
    ).value.fold((l) => l.messageKey, (r) => null);
  }

  @override
  final Either<CoreException, String> value;
}
