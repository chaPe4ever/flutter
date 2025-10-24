## Adding External Packages

This is a guide on how to add external packages from the flutter repository to your Flutter project.

- For any external package added in the project, check the available apis it exposes and make use of them in your project.

### Adding Core external package

- add in the project's `pubspec.yaml` under dependencies:

```yaml
  core:
    git:
      url: https://github.com/chaPe4ever/flutter
      ref: main
      path: pkg/core
```

## A list of the packages that core package exposes:
  - async: ^2.13.0
  - cached_network_image: ^3.4.1
  - cloud_firestore: ^5.6.11
  - cloud_functions: ^5.6.1
  - connectivity_plus: ^6.1.4
  - dartz: ^0.10.1
  - device_info_plus: ^11.5.0
  - dio: ^5.8.0+1
  - easy_localization: ^3.0.7
  - equatable: ^2.0.7
  - faker: ^2.2.0
  - firebase_core: ^3.15.1
  - firebase_database: ^11.3.9
  - flutter_hooks: ^0.21.2
  - flutter_pdfview: ^1.4.1
  - flutter_svg: ^2.2.0
  - flutter_timezone: ^4.1.1
  - freezed_annotation: ^3.1.0
  - gap: ^3.0.1
  - go_router: ^16.0.0
  - google_fonts: ^6.2.1
  - hooks_riverpod: ^2.6.1
  - json_annotation: ^4.9.0
  - logger: ^2.6.0
  - package_info_plus: ^8.3.0
  - path_provider: ^2.1.5
  - pdfrx: ^1.3.1
  - permission_handler: ^12.0.1
  - pretty_dio_logger: ^1.4.0
  - responsive_framework: ^1.5.1
  - riverpod_annotation: ^2.6.1
  - rxdart: ^0.28.0
  - share_plus: ^11.0.0
  - shared_preferences: ^2.5.3
  - shimmer: ^3.0.0
  - signals: ^6.0.2
  - timezone: ^0.10.1
  - url_launcher: ^6.3.1
  - uuid: ^4.5.1
  - widgetbook: ^3.14.3
  - widgetbook_annotation: ^3.5.0
  - window_manager: ^0.5.0