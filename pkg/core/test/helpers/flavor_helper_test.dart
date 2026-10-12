import 'package:core/core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _flavorChannel = MethodChannel('flavor');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_flavorChannel, null);
  });

  group('FlavorHelper.init', () {
    test('returns test flavor without platform calls', () async {
      final result = await FlavorHelper.init(testFlavorEnum: FlavorEnum.dev);
      expect(result, right<CoreException, FlavorEnum>(FlavorEnum.dev));
    });

    test('reads dev stg and prod from platform channel', () async {
      for (final entry in {
        'dev': FlavorEnum.dev,
        'stg': FlavorEnum.stg,
        'prod': FlavorEnum.prod,
      }.entries) {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              _flavorChannel,
              (call) async => entry.key,
            );

        final result = await FlavorHelper.init();
        expect(result, right<CoreException, FlavorEnum>(entry.value));
        expect(FlavorHelper.currentFlavor, entry.value);
      }
    });

    test('returns left when flavor is empty', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_flavorChannel, (call) async => '');

      final result = await FlavorHelper.init();
      expect(result.isLeft(), isTrue);
    });

    test('returns left when flavor is unknown', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_flavorChannel, (call) async => 'qa');

      final result = await FlavorHelper.init();
      expect(result.isLeft(), isTrue);
    });

    test('returns left when platform channel throws', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            _flavorChannel,
            (call) async => throw PlatformException(code: 'err'),
          );

      final result = await FlavorHelper.init();
      expect(result.isLeft(), isTrue);
    });
  });
}
