# Enhanced enums (Dart / Flutter)

Quick reference: Dart enhanced enums let enum values have fields, constructors, methods, and implement interfaces. Use them to represent small closed ADTs with associated data and behavior.

## Why use them
- Replace small sealed classes or static maps with a single type.
- Keep behavior close to data (methods, formatting, JSON helpers).
- Type-safe iteration and switch/case support.

## Basic enhanced enum
```dart
enum Status {
    pending(0),
    approved(1),
    rejected(2);

    final int code;
    const Status(this.code);

    bool get isFinal => this == Status.approved || this == Status.rejected;
    String label() {
        return name.toUpperCase();
    }

    static Status fromCode(int code) =>
            values.firstWhere((v) => v.code == code, orElse: () => Status.pending);
}
```

## Example: enum with UI helpers (Flutter)
```dart
import 'package:flutter/widgets.dart';

enum AppTheme {
    light(
        background: Color(0xFFFFFFFF),
        text: Color(0xFF000000),
    ),
    dark(
        background: Color(0xFF000000),
        text: Color(0xFFFFFFFF),
    );

    final Color background;
    final Color text;
    const AppTheme({required this.background, required this.text});

    ThemeData toThemeData() => ThemeData(
        scaffoldBackgroundColor: background,
        textTheme: TextTheme(bodyText1: TextStyle(color: text)),
    );
}
```

## JSON/serialization pattern
```dart
enum Level {
    low, medium, high;

    String toJson() => name;
    static Level fromJson(String s) => Level.values.byName(s); // Dart 2.15+
}
```

## Tips
- Use `const` constructors and final fields.
- Implement interfaces if you need polymorphic behavior.
- Prefer `values.byName` / `values.byValue` helpers available in newer Dart versions.
- Keep enums small and focused; for many variants with complex payloads, consider sealed classes / union types.

References: look up "Dart enhanced enums" in Dart language docs for version-specific features.