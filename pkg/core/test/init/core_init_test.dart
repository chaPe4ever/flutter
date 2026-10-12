import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../shared/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  group('Core.init', () {
    test('returns a container on success', () async {
      final result = await Core.init(
        themeBase: _TestThemeBase(),
        loggerBase: FakeLogger(),
        networkBase: _FakeNetwork(),
        localStorageBase: FakeLocalStorage(),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('expected success'),
        (container) {
          expect(container, isA<ProviderContainer>());
          container.dispose();
        },
      );
    });

    test('returns left when onPostInit throws CoreException', () async {
      final logger = FakeLogger();
      final result = await Core.init(
        themeBase: _TestThemeBase(),
        loggerBase: logger,
        onPostInit: (_) async {
          throw const StorageInitialisationException();
        },
      );

      expect(result.isLeft(), isTrue);
      expect(logger.errorMessages, isNotEmpty);
      result.fold(
        (error) => expect(error, isA<StorageInitialisationException>()),
        (_) => fail('expected failure'),
      );
    });

    test('wraps unknown exceptions as UnknownCoreException', () async {
      final logger = FakeLogger();
      final result = await Core.init(
        themeBase: _TestThemeBase(),
        loggerBase: logger,
        onPostInit: (_) async {
          throw Exception('boom');
        },
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<UnknownCoreException>()),
        (_) => fail('expected failure'),
      );
      expect(logger.errorMessages, isNotEmpty);
    });

    test('initialises app config when provided', () async {
      final result = await Core.init(
        themeBase: _TestThemeBase(),
        loggerBase: FakeLogger(),
        appConfig: AppConfig(configs: [_TestAppConfig()]),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('expected success'),
        (container) => container.dispose(),
      );
    });

    test('applies logger and network overrides', () async {
      final logger = FakeLogger();
      final network = _FakeNetwork();

      final result = await Core.init(
        themeBase: _TestThemeBase(),
        loggerBase: logger,
        networkBase: network,
      );

      result.fold(
        (_) => fail('expected success'),
        (container) {
          expect(container.read(loggerPod), same(logger));
          expect(container.read(networkPod), same(network));
          container.dispose();
        },
      );
    });
  });
}

final class _TestThemeBase implements ThemeBase {
  @override
  ColorScheme get colorSchemeLight => const ColorScheme.light();

  @override
  ColorScheme get colorSchemeDark => const ColorScheme.dark();

  @override
  ThemeData light(BuildContext context) =>
      ThemeData(colorScheme: colorSchemeLight);

  @override
  ThemeData dark(BuildContext context) =>
      ThemeData(colorScheme: colorSchemeDark);
}

final class _TestAppConfig implements ConfigBase {
  @override
  Future<void> init() async {}
}

final class _FakeNetwork implements NetworkBase {
  @override
  void addListener({void Function()? onOnline, void Function()? onOffline}) {}

  @override
  Stream<NetworkStatus> get connectionStatusStream => const Stream.empty();

  @override
  void dispose() {}

  @override
  Future<bool> get isConnected async => true;

  @override
  void removeListener({
    void Function()? onOnline,
    void Function()? onOffline,
  }) {}
}
