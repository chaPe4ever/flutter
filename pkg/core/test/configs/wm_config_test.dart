import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  group('WmConfig.init', () {
    test('no-ops on non-desktop platforms', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      await expectLater(WmConfig().init(), completes);
    });

    test('accepts custom screen dimension overrides on non-desktop', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      await expectLater(
        WmConfig().init(
          minScreenWidth: 400,
          defaultScreenWidth: 800,
          minScreenHeight: 500,
          defaultScreenHeight: 900,
          maxScreenWidth: 1600,
          maxScreenHeight: 1200,
        ),
        completes,
      );
    });
  });
}
