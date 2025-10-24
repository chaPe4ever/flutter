# Public constructor arguments

Summary
- For public constructors (those without a leading `_`), prefer named parameters over positional parameters.
- Use `required` for arguments that callers must supply, provide sensible defaults for optional parameters, and document each parameter.
- Prefer `const` and immutable fields where possible.

Problem
- Positional parameters are hard to read at call sites and make adding new parameters a breaking change.
- Lack of `required` or defaults can lead to runtime errors or ambiguous APIs.

Guidelines
- Use named parameters for public constructors to improve readability and future-proof the API.
- Mark required arguments with `required`.
- Give optional parameters default values when reasonable.
- Use `assert` (or validation in a factory) to enforce invariants.
- Make classes `@immutable` and fields `final` when instances are intended to be immutable.
- Use `const` constructors when possible to allow compile-time constants.
- Document each parameter with a doc comment.

Recommended pattern (Dart/Flutter)
```dart
@immutable
class Person {
    const Person({
        required this.name,
        this.age = 0,
        this.nickname,
    }) : assert(name != '');

    final String name;
    final int age;
    final String? nickname;
}
```

Why this is safer
- Named params improve readability: `Person(name: 'Alex', age: 30)` vs `Person('Alex', 30)`.
- Adding a new optional named parameter doesn't break existing callers.
- `required` makes intent explicit and surface errors at compile time.
- `const` and `final` help with performance and reasoning about state.

When to use positional parameters
- Use positional parameters for private/internal constructors or very small APIs where the meaning is obvious and unlikely to change (e.g., simple tuple-like types).
- Prefer positional only for 1–2 parameters with universally understood order; otherwise use named.

Breaking-change considerations
- Adding a new required positional or named parameter is a breaking change.
- Adding a new optional named parameter with a default is generally non-breaking.
- Avoid relying on argument order in public APIs.

Checklist for public constructors
- [ ] Are the parameters named for clarity?
- [ ] Are required values marked `required`?
- [ ] Do optional parameters have sensible defaults?
- [ ] Is the class immutable if intended?
- [ ] Is the constructor `const` when possible?
- [ ] Are parameters and behavior documented?

Examples: factory for validation
```dart
class Email {
    const Email._(this.value);

    factory Email(String input) {
        if (!_isValidEmail(input)) {
            throw ArgumentError.value(input, 'input', 'Invalid email');
        }
        return Email._(input);
    }
    final String value;
}
```