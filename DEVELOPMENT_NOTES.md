# Flutter Project Development Notes

## Project Structure

This is a **Melos monorepo** containing multiple Flutter packages:

```
flutter/
├── builders/           # Custom code generators and annotations
│   ├── custom_annotations/  # Custom annotations for code generation
│   └── custom_builders/     # Custom build_runner generators
├── pkg/               # Flutter packages
│   ├── core/          # Core functionality (shared across all packages)
│   ├── ads/           # Advertisement functionality
│   ├── analytics/     # Analytics functionality
│   ├── authentication/ # Authentication functionality
│   ├── crashlytics/   # Crash reporting
│   ├── inapp_review/  # In-app review functionality
│   ├── local_notifications/ # Local notifications
│   ├── remote_config/ # Remote configuration
│   ├── remote_storage/ # Remote storage functionality
│   └── shared_ui/     # Shared UI components
└── melos.yaml         # Melos workspace configuration
```

## Key Technologies & Patterns

### 1. State Management
- **Riverpod** with custom suffix "Pod" for providers
- **Signals** for reactive state management
- **Hooks** for Flutter widget lifecycle management

### 2. Code Generation
- **Freezed** for immutable data classes
- **JSON Serializable** for JSON serialization
- **Riverpod Generator** for provider generation
- **Custom Builders** for project-specific code generation

### 3. Architecture
- **Clean Architecture** with contracts, implementations, and exceptions
- **Value Objects** pattern for domain modeling
- **Either** type from dartz for error handling
- **Repository Pattern** with base contracts

## Freezed Migration (v2 to v3)

**Important**: This project uses Freezed v3. For migration from v2 to v3, see the [official changelog](https://pub.dev/packages/freezed/changelog).

### Key Changes in Freezed v3:
- **Breaking**: Removed `map/when` methods (use Dart pattern matching instead)
- **Breaking**: Classes must now be `abstract`, `sealed`, or manually implement `_$MyClass`
- **New**: Mixed mode support for simple classes and unions
- **New**: Inheritance and non-constant default values support
- **New**: "Eject" union cases to custom classes

### Migration Strategy:
1. Replace `map/when` with Dart pattern matching
2. Add `abstract` or `sealed` to Freezed classes
3. Update any inheritance patterns
4. Regenerate code with `dart run build_runner build --delete-conflicting-outputs`

## Build System Configuration

### Melos Commands
```bash
# Bootstrap all packages
melos bootstrap

# Run tests
melos test                    # All packages
melos test_changed           # Only changed packages

# Code quality
melos format                 # Format all code
melos analyze                # Analyze all packages

# Build runner
melos build_runner_build     # Build all generated code
melos build_runner_clean     # Clean generated files
melos build_runner_watch     # Watch for changes
```

### Package-Specific Build Runner
```bash
cd pkg/core
dart run build_runner build --delete-conflicting-outputs
```

## Code Generation Patterns

### 1. Freezed Models
```dart
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

@freezed
abstract class MyModel with _$MyModel {
  const factory MyModel({
    required String name,
    required int value,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

### 2. Riverpod Providers
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class MyProvider extends _$MyProvider {
  @override
  FutureOr<String> build() async {
    return 'Hello World';
  }
}
```

### 3. Custom Code Generators
```dart
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class MyGenerator extends GeneratorForAnnotation<MyAnnotation> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,  // Use Element2 for new code
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    // Generation logic
  }
}
```

## Package Dependencies

### Core Package Dependencies
- **State Management**: riverpod, signals, hooks_riverpod
- **Networking**: dio, pretty_dio_logger
- **Firebase**: firebase_core, firebase_database, cloud_firestore
- **UI**: flutter_svg, shimmer, gap
- **Utilities**: dartz, equatable, uuid, logger
- **Code Generation**: freezed_annotation, json_annotation, riverpod_annotation

### Development Dependencies
- **Build Tools**: build_runner, freezed, json_serializable, riverpod_generator
- **Testing**: flutter_test, mockito, integration_test
- **Linting**: very_good_analysis, custom_lint, riverpod_lint

## Migration Notes

### Analyzer Element Model Migration
The project is in transition from the old analyzer element model to the new one:
- Old: `Element`, `ClassElement`, `FieldElement`
- New: `Element2`, `ClassElement2`, `FieldElement2`

**Migration Strategy**:
1. For new code: Use the new element model
2. For existing generators: Suppress deprecation warnings until source_gen updates
3. For visitors: Use `SimpleElementVisitor2` with new element types

### Property Name Changes
- `element.name` → `element.displayName` (in new element model)
- `element.type` → `element.type` (unchanged)

## Development Workflow

1. **Start Development**:
   ```bash
   melos bootstrap
   melos build_runner_build
   ```

2. **Make Changes**:
   - Edit source files
   - Run `melos build_runner_watch` in background for auto-generation

3. **Test Changes**:
   ```bash
   melos test_changed
   melos analyze
   ```

4. **Format Code**:
   ```bash
   melos format
   ```

## Common File Patterns

### Package Structure
```
pkg/[package_name]/
├── lib/
│   ├── contracts/     # Abstract interfaces
│   ├── implementations/ # Concrete implementations
│   ├── exceptions/    # Custom exceptions
│   ├── constants/     # Constants and enums
│   ├── pods/          # Riverpod providers
│   └── [package_name].dart # Main export file
├── test/
├── pubspec.yaml
└── build.yaml
```

### Core Package Exports
The core package exports all common dependencies and utilities:
```dart
// pkg/core/lib/core.dart
export 'package:riverpod/riverpod.dart';
export 'package:freezed_annotation/freezed_annotation.dart';
// ... many more exports
```

This centralized export pattern allows other packages to import everything from `package:core/core.dart`.
