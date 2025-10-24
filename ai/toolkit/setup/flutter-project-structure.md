# Flutter project structure — Clean Architecture + Core

A concise, production-ready folder layout that separates concerns into feature modules and shared core utilities. Use one feature per package/folder with three main layers: presentation, domain, data. Keep reusable code in `core`.

```
lib/
├── core/
│   ├── errors/ (extends the CoreException class from "package:core/core.dart")
│   │   └── failures.dart
│   ├── extensions/
│   │   └── context_extensions.dart
│   ├── utils/
│   │   ├── date_helper.dart
│   │   └── env_helper.dart
│   │   └── alc_observer.dart
│   │   └── value_objects/ (extends the core pkg value objects (ValueObject<Type>) from "package:core/core.dart")
│   │       └── user_name.dart
│   ├── constants/
│   │   └── app_constants.dart               
│   ├── enums/
│   │   └── app_enums.dart
│   ├── routing/
│   │   └── router.dart (uses go_router package)
│   │   └── app_routes.dart (uses go_router_builder package which adds tyoe safety. e.g. @TypedGoRoute<Home>(path: '/') )
│   │   └── app_startup.dart             
│   ├── configs/ (extends the core pkg ConfigBase class from "package:core/core.dart")
│   │   └── app_firebase_config.dart
│   │   └── sentry_config.dart
│   ├── widgets/ (shared reusable widgets)
│   │   └── reusable_widget.dart
│   └── theme/
│       └── app_theme.dart (extends the ThemeBase from "package:core/core.dart")
│   └── widgetbooks/
│       └── widgets.dart (uses widgetbook package and annotation from "package:core/core.dart" for the reusable widgets)

├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_rds.dart (rds stand for remote data source)
│   │   │   │   └── fake_auth_rds_impl.dart (mimics remote source for testing)
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repo_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repo.dart (repo stands for repository)
│   │   │   └── usecases/
│   │   │       └── login_usecase.dart (extends the core pkg usecases from "package:core/core.dart")
│   │   └── presentation/
│   │       ├── providers/                     # or provider, cubit, riverpod folders
│   │       │   └── auth_provider.dart (uses Riverpod StateNotifier from "package:core/core.dart. Make use of usecases from domain layer)")
│   │       ├── pages/
│   │       │   └── login_page.dart (uses Riverpod ConsumerWidget from "package:core/core.dart")
│   │       └── widgets/
│   │           └── login_form.dart (try to keep it stateless dummy widgets, no logic)
│   └── home/
│       └── ...
├── l10n/                                  # localization ARB files / generated
├── main.dart
├── app.dart
test/
├── core/
├── features/
└── ...
```

Naming & conventions
- Files: snake_case, classes: PascalCase.
- Repositories in domain define contracts; implementations live in data and are injected.
- Keep business logic in domain layer (use cases, entities). Presentation only orchestrates and renders.

Guidelines
- Don't hardcode strings, use localization (ARB files in `l10n/`).
- Don't put logic in widgets; use providers/usecases.
- Dont hardcode fontSize/fontWeight. use theme properties.
- Mock network requests in tests with http_mock_adapter.
- Use spacing constants from AppSpacing or similar (create if missing and enrich when possible).
- Use eager provider initialization pattern for async dependencies (e.g., SharedPreferences) or dependencies needed to be Singleton at app startup.
- Use enhanced enums with members and methods for better type safety and code clarity.
- Create reusable widgets classes, never use build helper methods inside widgets (see widget-classes-no-build-helpers.md).
- Access eagerly initialized providers with .requiredValue (e.g., `ref.read(sharedPrefsProvider.requiredValue)`).
- Assume build_runner is running in watch mode during development for code generation
- Enrich whenever is needed the build_context_extensions (create if missing in core folder) with common helper methods that required context usage across the app.


This layout is adaptable: prefer feature-first when app grows, keep core minimal and focused on cross-cutting concerns.