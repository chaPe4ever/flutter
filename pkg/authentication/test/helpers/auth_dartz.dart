import 'package:authentication/exceptions/auth_exceptions.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';

export 'package:core/core.dart';

Option<AuthenticationEx> authNone() => none<AuthenticationEx>();

Option<AuthenticationEx> authSome(AuthenticationEx value) =>
    some<AuthenticationEx>(value);

Either<AuthenticationEx, T> authLeft<T>(AuthenticationEx value) =>
    left<AuthenticationEx, T>(value);

Either<AuthenticationEx, T> authRight<T>(T value) =>
    right<AuthenticationEx, T>(value);

Either<CoreException, String> validationLeft(CoreException value) =>
    left<CoreException, String>(value);

Option<User> authUserSome(User value) => some<User>(value);

Option<User> authUserNone() => none<User>();
