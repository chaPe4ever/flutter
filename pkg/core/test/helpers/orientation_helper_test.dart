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
    OrientationHelper.init();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_orientationChannel, (_) async => null);
  });

  group('orientationExceptionMessage', () {
    test('returns platform message for PlatformException', () {
      expect(
        orientationExceptionMessage(
          PlatformException(code: 'err', message: 'blocked'),
        ),
        'blocked',
      );
    });

    test('returns toString for other exceptions in debug mode', () {
      expect(
        orientationExceptionMessage(const FormatException('bad orient')),
        contains('FormatException'),
      );
    });
  });

  group('OrientationHelper.setOrientation', () {
    test('returns some when orientations list is empty', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      final result = await OrientationHelper.setOrientation(
        orientations: const [],
      );

      expect(result, isA<Some<CoreException>>());
    });

    test('returns none on android when orientations are valid', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      final result = await OrientationHelper.setOrientation(
        orientations: const [DeviceOrientation.portraitUp],
      );

      expect(result, none<CoreException>());
    });

    test('returns some on unsupported desktop platform', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

      final result = await OrientationHelper.setOrientation(
        orientations: const [DeviceOrientation.portraitUp],
      );

      expect(result, isA<Some<CoreException>>());
    });

    test('invokes ios platform channel for portraitUp', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      String? invokedArg;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_orientationChannel, (call) async {
            invokedArg = call.arguments as String?;
            return null;
          });

      final result = await OrientationHelper.setOrientation(
        orientations: const [DeviceOrientation.portraitUp],
      );

      expect(result, none<CoreException>());
      expect(invokedArg, DeviceOrientation.portraitUp.name);
    });

    test('returns some when ios channel throws generic exception', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            _orientationChannel,
            (_) async => throw const FormatException('orientation fail'),
          );

      final result = await OrientationHelper.setOrientation(
        orientations: const [DeviceOrientation.portraitUp],
      );

      expect(result, isA<Some<CoreException>>());
    });

    test('returns some when ios platform channel throws', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            _orientationChannel,
            (call) async =>
                throw PlatformException(code: 'err', message: 'fail'),
          );

      final result = await OrientationHelper.setOrientation(
        orientations: const [DeviceOrientation.portraitUp],
      );

      expect(result, isA<Some<CoreException>>());
    });
  });
}
