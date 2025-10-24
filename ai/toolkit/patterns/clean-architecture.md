# Clean Architecture for this Flutter project

Purpose
- Provide a consistent, testable, scalable structure for features.
- Enforce clear dependency rules so UI and infrastructure can change independently.
- Reuse common base types and patterns from package:core/core.dart.

Principles
- Single Responsibility per file/module.
- Dependency Rule: outer layers (presentation, data) depend on inner layers (domain). Domain must not depend on presentation or data.
- Use interfaces/abstractions for external dependencies (repositories, data sources).
- Keep pure business logic in domain layer to make unit testing trivial.
- Extend base classes from package:core where appropriate (ConfigBase, CoreException, ThemeBase, ValueObject, UseCase, StateNotifier helpers).

Recommended top-level layout (under `/lib`)

```
lib/
├── core/
│   ├── errors/                  # extends CoreException from "package:core/core.dart"
│   │   └── failures.dart
│   ├── extensions/
│   │   └── context_extensions.dart
│   ├── utils/
│   │   ├── date_helper.dart
│   │   ├── env_helper.dart
│   │   ├── alc_observer.dart
│   │   └── value_objects/       # extends ValueObject<Type> from "package:core/core.dart"
│   │       └── user_name.dart
│   ├── constants/
│   │   └── app_constants.dart
│   ├── enums/
│   │   └── app_enums.dart
│   ├── routing/
│   │   ├── router.dart          # uses go_router
│   │   ├── app_routes.dart      # uses go_router_builder with @TypedGoRoute
│   │   └── app_startup.dart
│   ├── configs/                 # extends ConfigBase from "package:core/core.dart"
│   │   ├── app_firebase_config.dart
│   │   └── sentry_config.dart
│   ├── widgets/                 # shared reusable widgets
│   │   └── reusable_widget.dart
│   ├── theme/
│   │   └── app_theme.dart       # extends ThemeBase from "package:core/core.dart"
│   └── widgetbooks/
│       └── widgets.dart         # uses widgetbook and annotations from "package:core/core.dart"
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_rds.dart             # remote data source (RDS)
│   │   │   │   └── fake_auth_rds_impl.dart   # fake implementation for tests
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repo_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repo.dart            # interface only
│   │   │   └── usecases/
│   │   │       └── login_usecase.dart        # extends UseCase from "package:core/core.dart"
│   │   └── presentation/
│   │       ├── providers/                    # e.g., Riverpod StateNotifier (from core)
│   │       │   └── auth_provider.dart
│   │       ├── pages/
│   │       │   └── login_page.dart
│   │       └── widgets/
│   │           └── login_form.dart           # keep stateless, UI-only
│   └── home/
│       └── ...
├── l10n/                                     # localization ARB files / generated
├── injection_container.dart                  # DI setup (get_it / injectable or Riverpod providers)
├── app.dart
└── main.dart
test/
├── core/
├── features/
└── ...
```

Layer responsibilities
- Domain
    - Entities: plain classes representing business objects.
    - Repositories: abstract interfaces exposing operations (e.g., auth_repo.dart).
    - UseCases (or Interactors): orchestrate business logic; extend core UseCase base where available.
- Data
    - Models: DTOs, JSON serialization, mapping to/from Entities. Use Equatable pkg (already included in core pkg) for value equality.
    - DataSources: concrete remote/local implementations (naming convention: *_rds.dart for remote data source, *_lds.dart for local data source); include fakes for tests. The data source files consist of the abstract interface class and the concrete implementation class in the same file for better cohesion.(e.g., auth_rds.dart contains AuthRds abstract interface and AuthRdsImpl class).
    - Repositories (impl): implement domain repositories, use datasources and mappers (repositories/ folder in data).
- Presentation
    - State management: prefer core-provided patterns (StateNotifier/riverpod from package:core/core.dart) or your chosen approach.
    - Widgets, pages, navigation and UI-only formatting.
- Core
    - Shared utilities, base exceptions (CoreException), network helpers, constants, theme, widgetbook annotations and reusable components.

Dependency and mapping rules
- Domain -> must not import data/presentation.
- Data imports domain (entities, repository interfaces).
- Presentation imports domain (usecases/entities) and receives repository implementations via DI (avoid direct data imports from presentation).
- Map Models <-> Entities in Data layer using small mappers or factory constructors.

Dependency Injection 
- Leverage Riverpod as the injection pattern and use the keepAlive: true flag for singletons where needed.:
    - UseCases -> repository interfaces.
    - Repositories -> concrete RepositoryImpl.
    - DataSources (e.g., auth_rds) -> implementations (real and fake).
    - External clients (http, db, shared_preferences, firebase).
- Use patterns provided by package:core if available (e.g., standardized registration helpers).
- Example libraries: Riverpod providers, go_router_builder for type-safe routes.

State management guidance
- Keep business logic in usecases and providers/StateNotifiers; widgets should be dumb renderers.
- Use small, focused providers per feature or page.
- Prefer Riverpod/StateNotifier (integrated via package:core/core.dart) for testability and DI friendliness.
- For local state inside widgets use the Flutter Hooks (already included in core package).

Tests
- Domain: unit tests for usecases and entities (no external dependencies).
- Data: repository impl tests with mocked datasources; model serialization tests; include fake_rds tests.
- Presentation: provider/StateNotifier tests and widget tests.
- Use mockito or mocktail, or fakes from data/datasources for fast tests.
- Keep mirrored test structure under /test/core and /test/features.
- For widget tests use the robot pattern for better readability and maintainability.

Naming conventions
- auth_repo.dart (domain/repositories)
- auth_repo_impl.dart (data/repositories)
- auth_rds.dart / fake_auth_rds_impl.dart (data/datasources)
- login_usecase.dart (domain/usecases)
- user_model.dart, user_entity.dart

Examples (short)
- domain/repositories/auth_repo.dart
- domain/usecases/login_usecase.dart (extends core UseCase)
- data/datasources/auth_rds.dart
- data/models/user_model.dart
- data/repositories/auth_repo_impl.dart
- presentation/providers/auth_provider.dart
- presentation/pages/login_page.dart

CI and tooling
- Enforce linting: analysis_options.yaml (from include: package:very_good_analysis/analysis_options.yaml).
- Add unit/widget/lint checks to CI.
- Use build_runner for code generation (json_serializable, go_router_builder, injectable).
- Integrate widgetbook for component review (core/widgetbooks).

Migration checklist (from existing project)
- Identify domain objects and extract them to domain layer.
- Introduce repository interfaces and replace direct data calls with usecases.
- Move API/DB code into datasources (auth_rds) and repository implementations.
- Add DI (through Riverpod) and register implementations + fakes for tests.
- Convert UI to depend on providers/usecases instead of direct data calls.
- Add tests at each layer iteratively.

Notes
- Prefer extending and reusing base classes from package:core/core.dart where appropriate (exceptions, configs, usecases, value objects, theme, widgetbook annotations).
- Keep domain as small and pure as possible.
- Start simple: apply clean architecture per feature incrementally. Document layer contracts in README inside each feature folder.
