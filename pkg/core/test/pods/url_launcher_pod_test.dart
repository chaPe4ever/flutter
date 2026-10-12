import 'package:core/core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('urlLauncherPod', () {
    test('returns some LaunchUrlException when launch fails', () async {
      const channel = MethodChannel('plugins.flutter.io/url_launcher');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (_) async => false);
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final launcher = container.read(urlLauncherPod);
      final result = await launcher.call(urlString: 'https://example.com');

      expect(result, isA<Some<CoreException>>());
      result.fold(
        () => fail('expected failure'),
        (error) => expect(error, isA<LaunchUrlException>()),
      );
    });

    test('returns some when url cannot be parsed', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container
          .read(urlLauncherPod)
          .call(
            urlString: ':',
          );

      expect(result, isA<Some<CoreException>>());
    });

    test('returns none when launch succeeds', () async {
      const channel = MethodChannel('plugins.flutter.io/url_launcher');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (_) async => true);
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container
          .read(urlLauncherPod)
          .call(
            urlString: 'https://example.com',
            mode: UrlLaunchModeEnum.inAppWebView,
            webOnlyWindowName: 'gameroom',
          );

      expect(result, none<CoreException>());
    });

    test('returns some when platform channel throws', () async {
      const channel = MethodChannel('plugins.flutter.io/url_launcher');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            channel,
            (_) async =>
                throw PlatformException(code: 'err', message: 'blocked'),
          );
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container
          .read(urlLauncherPod)
          .call(
            urlString: 'https://example.com',
          );

      expect(result, isA<Some<CoreException>>());
      result.fold(
        () => fail('expected failure'),
        (error) => expect(error, isA<LaunchUrlException>()),
      );
    });
  });
}
