import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _orientationChannel = MethodChannel('core/orientation');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_orientationChannel, null);
  });

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    OrientationHelper.init();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_orientationChannel, (_) async => null);
  });

  group('OrientationHelper iOS branches', () {
    test('single-orientation switch cases invoke platform channel', () async {
      for (final orientation in DeviceOrientation.values) {
        final result = await OrientationHelper.setOrientation(
          orientations: [orientation],
        );
        expect(result, none<CoreException>());
      }
    });

    test('multi-orientation presets invoke platform channel', () async {
      final presets = <List<DeviceOrientation>>[
        DeviceOrientation.values,
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
        ],
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
        ],
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        [
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeRight,
        ],
        [
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
        ],
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
        ],
        [
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
        ],
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
        [DeviceOrientation.portraitUp],
        [DeviceOrientation.portraitDown],
        [DeviceOrientation.landscapeRight],
        [DeviceOrientation.landscapeLeft],
      ];

      for (final orientations in presets) {
        final result = await OrientationHelper.setOrientation(
          orientations: orientations,
        );
        expect(result, none<CoreException>());
      }
    });

    test('returns some when generic exception is thrown', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            _orientationChannel,
            (_) async => throw const FormatException('fail'),
          );

      final result = await OrientationHelper.setOrientation(
        orientations: const [DeviceOrientation.portraitUp],
      );

      expect(result, isA<Some<CoreException>>());
    });
  });
}
