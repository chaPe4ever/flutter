# Error handling — extending CoreException

This document shows a recommended pattern for application exceptions that extend `CoreException` from the `core` package. Keep exceptions small, typed, serializable, and easy to map to UI messages or error codes.

## When to extend CoreException
- Use for domain or infrastructure errors you want to inspect, map or serialize.
- Keep throwing code concise (`throw SomeException(...)`) and handle at boundaries (bloc/provider/middleware).

## Base example

```dart
import 'package:core/core.dart';

sealed class AppClientEx extends CoreException {
  const AppClientEx({
    required super.messageKey,
    super.prefix = 'game_room_client',
    super.innerError,
    super.innerCode,
    super.innerMessage,
    super.st,
  });
}

final class NoSignedInException extends AppClientEx {
  ///
  NotSignedInException({
    super.messageKey = 'user_is_not_signed_in_exception_message',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}
```


## Usage and handling

```dart
// Throwing
if (!isNotSignedIn) {
    throw NoSignedInException(innerMessage: 'User ID is null');
}

// Catching at boundary
- make use of the try_catch_helper.dart from core package -> lib/helpers/try_catch_helper.dart
```

## Recommendations
- Prefer small, focused exception classes with a stable `code`.
- Map exceptions to user-facing messages at the boundary; avoid leaking internal details to users.
- Log stack traces and raw exception objects to your centralized logging/observability.
- Use `sealed class` for base exceptions to restrict subclassing within the package.
- The messageKey should correspond to localization keys for easy i18n support.

This pattern keeps exceptions usable across layers and compatible with `CoreException` expectations from the `core` package.