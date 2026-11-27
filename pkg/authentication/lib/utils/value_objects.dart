import 'package:authentication/utils/validators.dart';
import 'package:core/core.dart';

///
final class EmailAddress extends ValueObject<String> {
  /// Ctr
  factory(String? input) {
    return EmailAddress._(validateEmailAddress(input));
  }

  const new _(this.value);

  /// Used on textField validator as as a tear-off
  @override
  String? validator(String? value) {
    return EmailAddress._(validateEmailAddress(value)).value
        .fold((l) => l.messageKey.tr(), (r) => null);
  }

  @override
  final Either<CoreException, String> value;
}

///
final class Password extends ValueObject<String> {
  ///
  factory(String? value) {
    return Password._(validatePassword(value));
  }

  const new _(this.value);

  @override
  String? validator(String? value) {
    return Password._(validatePassword(value)).value
        .fold((l) => l.messageKey.tr(), (r) => null);
  }

  @override
  final Either<CoreException, String> value;
}
