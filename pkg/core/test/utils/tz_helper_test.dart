import 'package:core/core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await TzHelper.init();
  });

  group('TzHelper', () {
    test('now returns DateTime for valid location', () {
      final dt = TzHelper.now('Europe/Berlin');
      expect(dt, isNotNull);
    });

    test('now returns null for invalid location', () {
      expect(TzHelper.now('Not/A_Real_Zone'), isNull);
    });

    test('eitherNow returns right for valid location', () {
      final result = TzHelper.eitherNow(tzLocationName: 'Europe/Berlin');
      expect(result.isRight(), isTrue);
    });

    test('eitherNow returns left for invalid location', () {
      final result = TzHelper.eitherNow(tzLocationName: 'Invalid/Zone');
      expect(result.isLeft(), isTrue);
    });

    test('from converts utc DateTime to timezone', () {
      final utc = DateTime.utc(2024, 1, 15, 12);
      final converted = TzHelper.from(utc, tzLocationName: 'Europe/Berlin');
      expect(converted, isNotNull);
    });

    test('eitherFrom returns right for valid conversion', () {
      final utc = DateTime.utc(2024, 1, 15, 12);
      final result = TzHelper.eitherFrom(
        other: utc,
        tzLocationName: 'Europe/Berlin',
      );
      expect(result.isRight(), isTrue);
    });

    test('parse parses formatted string', () {
      final parsed = TzHelper.parse(
        '2024-06-01 10:00:00',
        tzLocationName: 'Europe/Berlin',
      );
      expect(parsed, isNotNull);
    });

    test('eitherParse returns right for valid string', () {
      final result = TzHelper.eitherParse(
        formattedString: '2024-06-01 10:00:00',
        tzLocationName: 'Europe/Berlin',
      );
      expect(result.isRight(), isTrue);
    });

    test('eitherFrom returns left for invalid timezone', () {
      final result = TzHelper.eitherFrom(
        other: DateTime.utc(2024),
        tzLocationName: 'Invalid/Zone',
      );
      expect(result.isLeft(), isTrue);
    });

    test('eitherParse returns left for invalid timezone', () {
      final result = TzHelper.eitherParse(
        formattedString: '2024-06-01 10:00:00',
        tzLocationName: 'Invalid/Zone',
      );
      expect(result.isLeft(), isTrue);
    });

    test('isDeviceTzEqTo returns left when timezone lookup throws', () async {
      const channel = MethodChannel('flutter_timezone');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            channel,
            (_) async => throw Exception('timezone unavailable'),
          );
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      final result = await TzHelper.isDeviceTzEqTo('Europe/Berlin');
      expect(result.isLeft(), isTrue);
    });

    test('isDeviceTzEqTo compares device and app timezone', () async {
      const channel = MethodChannel('flutter_timezone');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            channel,
            (_) async => 'Europe/Berlin',
          );
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      final result = await TzHelper.isDeviceTzEqTo('Europe/Berlin');
      expect(result.isRight(), isTrue);
    });
  });
}
