import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await TzHelper.init();
  });

  group('DtHelper', () {
    test('parseTimeStr', () {
      final time = DtHelper.parseTimeStr('14:30');
      expect(time.hour, 14);
      expect(time.minute, 30);
    });

    test('utcTimeOfDayToLocationTz converts for valid zone', () {
      const utcTime = TimeOfDay(hour: 12, minute: 0);
      final local = DtHelper.utcTimeOfDayToLocationTz(
        utcTime,
        tzLocationName: 'Europe/Berlin',
      );
      expect(local, isNotNull);
    });

    test('utcTimeOfDayToLocationTz returns null for invalid zone', () {
      const utcTime = TimeOfDay(hour: 12, minute: 0);
      expect(
        DtHelper.utcTimeOfDayToLocationTz(
          utcTime,
          tzLocationName: 'Invalid/Zone',
        ),
        isNull,
      );
    });

    test('utcStrToLocationTzTimeOfDay parses and converts', () {
      final local = DtHelper.utcStrToLocationTzTimeOfDay(
        '08:15',
        tzLocationName: 'Europe/Berlin',
      );
      expect(local, isNotNull);
    });
  });
}
