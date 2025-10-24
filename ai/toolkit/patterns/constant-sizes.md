# Constant sizes (spacing) — patterns and tips

Short, practical patterns to manage spacing in Flutter apps. Inspired by best practices: centralize spacing, prefer const widgets, use semantic names, and keep responsiveness in mind.

## Why centralize spacing?
- Avoid magic numbers across widgets.
- Make global style changes easy.
- Use `const` where possible to reduce rebuild cost.

## Basic pattern — numeric constants
Create a central place for numeric values:

```dart
class AppSpacing {
    AppSpacing._();

    static const double s4 = 4.0;
    static const double s8 = 8.0;
    static const double s12 = 12.0;
    static const double s16 = 16.0;
    static const double s24 = 24.0;
    static const double s32 = 32.0;

    <!-- Use semantic names in addition to scales (recommended): -->
    <!-- Semantic tokens describe intent (e.g., `small`, `medium`) and map to numeric values in one place. -->
    static const double tiny = 4.0;
    static const double small = 8.0;
    static const double medium = 16.0;
    static const double large = 24.0;
    static const double xLarge = 40.0;
}
```

Use with EdgeInsets or SizedBox:

```dart
Padding(
    padding: const EdgeInsets.all(AppSpacing.s16),
    child: Column(
        children: const [
            Text('Title'),
            Text('Body text'),
        ],
    ),
)

```

## Pre-built `SizedBox` constants
Reuse `const` `SizedBox` instances to avoid rebuilding identical widgets:

```dart
class Gaps {
    Gaps._();

    static const SizedBox h4 = SizedBox(width: AppSpacing.s4);
    static const SizedBox h8 = SizedBox(width: AppSpacing.s8);
    static const SizedBox v8 = SizedBox(height: AppSpacing.s8);
    static const SizedBox v16 = SizedBox(height: AppSpacing.s16);
}
```

Usage:

```dart
Row(children: const [
    Icon(Icons.search),
    Gaps.h8,
    Expanded(child: TextField()),
]);
```

Because these are `const`, Flutter can reuse them across rebuilds.

## Lightweight DSL — extensions
Small extension gives concise syntax:

```dart
extension GapExt on num {
    SizedBox get v => SizedBox(height: toDouble());
    SizedBox get h => SizedBox(width: toDouble());
}
```

Usage: `8.v`, `16.h`. Keep in mind this is syntactic sugar — still prefer named constants for design systems.


## Alternatives
- Theme-based spacing: put spacing values into theme extensions for theming and runtime overrides.
- Responsive scales: multiply base spacing by a device scale or use breakpoints.

## Best practices
- Use `const` `SizedBox` where possible.
- Prefer semantic tokens for design intent.
- Keep one source of truth for numbers.
- Use small extension helpers for developer ergonomics, but avoid fragmenting your spacing system.
- Consider responsiveness separately from base spacing tokens.
