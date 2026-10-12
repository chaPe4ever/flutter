import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTimeX', () {
    test('remainingSecondsUntilNextHour', () {
      final dt = DateTime(2024, 6, 15, 10, 30);
      expect(dt.remainingSecondsUntilNextHour, 30 * 60);
    });

    test('remainingMinutesUntilNextHour', () {
      final dt = DateTime(2024, 6, 15, 10, 45);
      expect(dt.remainingMinutesUntilNextHour, 15);
    });

    test('roundToNearestHour rounds up at 30 minutes', () {
      final dt = DateTime(2024, 6, 15, 10, 30);
      expect(dt.roundToNearestHour, DateTime(2024, 6, 15, 11));
    });

    test('roundToNearestHour rounds up at 29:30', () {
      final dt = DateTime(2024, 6, 15, 10, 29, 30);
      expect(dt.roundToNearestHour, DateTime(2024, 6, 15, 11));
    });

    test('roundToNearestHour rounds down before half hour', () {
      final dt = DateTime(2024, 6, 15, 10, 29, 29);
      expect(dt.roundToNearestHour, DateTime(2024, 6, 15, 10));
    });

    test('tzRemainingSecondsUntilNextHour uses valid timezone', () async {
      await TzHelper.init();
      final result = DateTime.now().tzRemainingSecondsUntilNextHour(
        tzLocationName: 'Europe/Berlin',
      );
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('expected right'),
        (seconds) => expect(seconds, greaterThan(0)),
      );
    });
  });

  group('TimeOfDayX', () {
    test('leading zeros and formatHHmm', () {
      const time = TimeOfDay(hour: 9, minute: 5);
      expect(time.hourWithLeadingZero, '09');
      expect(time.minuteWithLeadingZero, '05');
      expect(time.formatHHmm, '09:05');
    });

    test('toDtNow uses today with given time', () {
      const time = TimeOfDay(hour: 14, minute: 30);
      final dt = time.toDtNow();
      expect(dt.hour, 14);
      expect(dt.minute, 30);
    });
  });
}
