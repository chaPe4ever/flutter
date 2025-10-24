# Dart Patterns — Quick Reference

A concise guide to Dart's pattern matching features (summary and examples, not exhaustive).

## Overview
Patterns let you test and destructure values in switches, `if`/`case`, and variable declarations. They can be combined and guarded with conditions.

Supported pattern kinds (common):
- Constant patterns (literals, enum values) — compare with `==`
- Variable patterns (`var`, `final`) — capture values
- Bare identifiers — treated as constant patterns unless prefixed with `var`/`final`
- Wildcard (`_`) — ignore value
- Type test patterns (`Type name`) — match by runtime type and bind
- Relational patterns (`>`, `<`, `>=`, `<=`) — numeric comparisons
- Logical patterns (`and`, `or`, `not`) — combine patterns
- List patterns (positional matching, `...` rest)
- Map patterns (match entries by key)
- Object patterns (destructure objects by their pattern fields / properties)
- Record patterns (positional / named fields)
- Guards (`when`) — extra boolean checks

Patterns may be nested and mixed to describe complex shapes. Use a `default` (or exhaustive patterns) in switches to handle unmatched cases.

## Pattern Types (enriched)

- Constant pattern
    - Matches when the value equals the constant (uses `==` semantics).
    - Can be literals, enum values, or compile-time constants.
    ```
    switch (value) {
        case 0:
            // matched zero
            break;
        case 'hello':
            // matched string
            break;
        case MyEnum.ready:
            // matched enum constant
            break;
    }
    ```

- Wildcard (ignore)
    - Use `_` to match anything without binding.
    ```
    case _:
        // fallback / ignore value
    ```

- Variable pattern (capture)
    - `var` or `final` introduces a fresh binding that always matches and captures the value.
    - A bare identifier (without `var`/`final`) is a constant pattern, not a capture.
    ```
    case var x:
        // x now holds the matched value (mutable)

    case final y:
        // y holds the matched value (immutable)
    ```

- Type test pattern (capture if type matches)
    - Matches when the value is of the given type (at runtime) and binds the variable with that type.
    ```
    case int n:
        // matches integers, n is int
    ```

- Relational patterns (numeric comparisons)
    - Simple numeric guards built into patterns.
    ```
    case >= 0:
        // non-negative numbers
    case < 0:
        // negative
    ```

- Logical patterns
    - Combine patterns using `and`, `or`, and negate with `not`.
    ```
    case >= 0 and < 10:
        // matches numbers 0..9
    case < 0 or >= 100:
        // matches two ranges
    case not 0:
        // any value except 0
    ```

- Guards (`when`)
    - Use `when` after a pattern to provide an extra boolean condition that must hold.
    ```
    case int n when n.isEven:
        // guard with when
    ```

- List patterns and rest
    - Match list shape positionally; capture remaining elements with `...var rest` or ignore remainder with `...`.
    ```
    switch (list) {
        case [1, 2, ...var rest]:
            // first two elements 1,2; rest is a list
            break;
        case [var head, ...]:
            // head is first element, ... ignores remainder
    }
    ```

- Map patterns
    - Match map entries by key and bind their values. Keys used in the pattern must exist in the map for the pattern to match.
    ```
    switch (m) {
        case {'x': var x, 'y': var y}:
            // captures values for keys 'x' and 'y'
            break;
    }
    ```

- Record patterns
    - Match record positional fields and named fields.
    ```
    var r = (1, 'a');
    switch (r) {
        case (var num, var str):
            // num == 1, str == 'a'
            break;
    }

    var rn = (id: 1, name: 'bob');
    switch (rn) {
        case (id: var id, name: var name):
            // captures named fields
    }
    ```

- Object patterns
    - Destructure objects using their exposed pattern fields (typically declared by the class). Object patterns match the runtime type and then match properties by name.
    ```
    class Point {
            final int x, y;
            Point(this.x, this.y);
            // if pattern fields are enabled for the class, you can match Point(x: ..., y: ...)
    }

    switch (value) {
            case Point(x: var xs, y: var ys):
                    // xs and ys captured from Point
                    break;
    }
    ```

- Nested patterns
    - Patterns can be nested arbitrarily (lists containing records, objects containing maps, etc.).
    ```
    case {'user': {'id': var id, 'roles': [var firstRole, ...]}}:
        // nested map and list patterns
    ```

## Syntax and behavior notes
- Use `var` or `final` to create captures. A bare identifier in a pattern is treated as a constant.
- Constant patterns compare using `==`.
- Type test patterns require the value to be of the given type at runtime.
- Patterns are checked top-to-bottom in switches; ensure exhaustive handling or include a `default`.
- Guards (`when`) run after the pattern matches and can use captured bindings.
- Patterns are composable — mix list, map, record, and object patterns to match complex shapes.
- `...` in a list pattern collects or ignores the tail of a list.

## Examples

- Switch with multiple pattern types
```
Object parse(Object value) {
        switch (value) {
                case 0:
                        return 'zero';
                case int n when n > 0:
                        return 'positive int $n';
                case String s:
                        return 'string: $s';
                case [var a, var b, ...]:
                        return 'two-or-more-element list, head=$a';
                case {'error': var e}:
                        return 'error: $e';
                case Point(x: var x, y: var y):
                        return 'Point at $x,$y';
                default:
                        return 'other';
        }
}
```

- If-case usage
```
if (obj case {'status': 'ok', 'data': var d}) {
        // use d
}
```

## Tips
- Use `_` to ignore values you don’t care about.
- `var` and `final` control mutability of captures.
- Guards (`when`) are useful for checks patterns can't express directly.
- Keep switch exhaustiveness in mind; add `default` when necessary.
- Consult the language docs for up-to-date details on object pattern declarations and advanced pattern features.

For full language details and the exact syntax and semantics, consult the Dart language specification or the official docs.