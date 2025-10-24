# Widget classes: avoid `_buildX()` helper methods

Summary
- Prefer composition and small widgets over private `_buildX()` helper methods inside widget classes.
- Keep `build` implementations declarative and rely on extracted widgets for clarity, reuse, and testability.
- If a single Dart file exceeds ~250 lines, split it into smaller widget files (see "File splitting" below).

Why avoid `_buildX()` helpers
- They hide UI structure inside imperative helper methods.
- Make widgets harder to reuse and test.
- Can grow large and undermine the declarative nature of Flutter.
- Extracted widgets are const-friendly and more likely to be tree-optimized.

Rules / patterns
- Never add private `_build...()` methods inside `StatelessWidget`/`State` classes.
- Extract parts of UI to small (preferably private) `Widget` classes.
- Keep constructors explicit and pass only required data.
- Favor `const` constructors where possible.
- For very small fragments, consider top-level or file-private functions that return `Widget` only when they are pure and trivial — still prefer classes for reusability.
- File splitting: if a file grows beyond ~250 lines, split it into multiple smaller files:
    - Keep the public widget (API entry point) in its own file, e.g. `profile_card.dart`.
    - Move extracted private widgets into one or more file-private files, e.g. `_profile_avatar.dart`, `_profile_name.dart`, `_profile_actions.dart`, or group related small widgets in `profile_card_parts.dart`.
    - Use file-private widget classes (leading underscore) to avoid polluting the public API.
    - Prefer one focused widget per file when a widget has substantial logic or layout.
    - For trivial pieces that are only a few lines, grouping into a single `*_parts.dart` is acceptable to reduce file proliferation.
    - Keep imports minimal and prefer relative paths; consider creating a barrel file only when it improves discoverability.

Bad example (avoid)
```dart
class ProfileCard extends StatelessWidget {
    final User user;
    const ProfileCard(this.user, {Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Card(
            child: Column(
                children: [
                    _buildAvatar(),
                    _buildName(),
                    _buildActions(),
                ],
            ),
        );
    }

    Widget _buildAvatar() => CircleAvatar(...);
    Widget _buildName() => Text(user.name);
    Widget _buildActions() => Row(...);
}
```

Good example (preferred)
```dart
// profile_card.dart
class ProfileCard extends StatelessWidget {
    final User user;
    const ProfileCard(this.user, {Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Card(
            child: Column(
                children: [
                    _ProfileAvatar(user: user),
                    _ProfileName(user: user),
                    const _ProfileActions(),
                ],
            ),
        );
    }
}

// _profile_avatar.dart (file-private)
class _ProfileAvatar extends StatelessWidget {
    final User user;
    const _ProfileAvatar({required this.user, Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) => CircleAvatar(...);
}
```

Notes
- For performance, extracted widgets with `const` constructors avoid rebuilds when possible.
- Keep each widget focused (single responsibility) and small — easier to unit-test and maintain.
- Use file-private widgets (leading underscore) to avoid polluting public API.
- When splitting files, preserve clear names and keep related widgets close to their parent widget's file tree.

Conventions to enforce in code reviews
- Reject PRs that use `_buildX()` helpers inside widgets.
- Encourage extraction of any helper method that returns `Widget` into a small widget class.
- Prefer composition over procedural helpers.
- Enforce splitting large files (>250 lines) into smaller widget files; request a file layout or brief rationale if the author resists.

References
- Keep it idiomatic: small reusable widget classes improve readability, testability, and performance.
- Use state-management / inherited widgets for shared data instead of passing through many constructors where appropriate.
