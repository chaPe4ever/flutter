import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _windowManagerChannel = MethodChannel('window_manager');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_windowManagerChannel, null);
  });

  group('WmConfig.init on desktop', () {
    test('initialises window manager on macOS', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_windowManagerChannel, (_) async => true);

      await WmConfig().init();
      await Future<void>.delayed(Duration.zero);
    });

    test('uses custom screen dimensions on macOS', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_windowManagerChannel, (_) async => true);

      await WmConfig().init(
        minScreenWidth: 400,
        defaultScreenWidth: 800,
        minScreenHeight: 500,
        defaultScreenHeight: 900,
        maxScreenWidth: 1600,
        maxScreenHeight: 1200,
      );
      await Future<void>.delayed(Duration.zero);
    });
  });
}
