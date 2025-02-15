import 'package:core/exceptions/core_exception.dart';
import 'package:core/utils/tz_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

/// DateTime extensions
extension DateTimeX on DateTime {
  /// Total seconds until next hour starting from DateTime.now
  int get remainingSecondsUntilNextHour =>
      DateTime(year, month, day, hour + 1).difference(this).inSeconds;

  /// Total minutes until next hour starting from DateTime.now
  int get remainingMinutesUntilNextHour => 60 - minute;

  /// Self explained
  DateTime get roundToNearestHour {
    final minutes = minute;
    final seconds = second;

    // If the minutes are closer to the next hour, round up
    if (minutes >= 30 || (minutes == 29 && seconds >= 30)) {
      final nextHour = hour + 1;
      return DateTime(year, month, day, nextHour);
    } else {
      // Otherwise, round down to the current hour
      return DateTime(year, month, day, hour);
    }
  }

  /// Total seconds until next hour starting from DateTime.now of a given
  /// [tzLocationName]
  Either<CoreException, int> tzRemainingSecondsUntilNextHour({
    required String tzLocationName,
  }) => TzHelper.eitherNow(tzLocationName: tzLocationName).fold(
    left,
    (dt) => right(
      dt
          .copyWith(
            hour: dt.hour + 1,
            minute: 0,
            second: 0,
            millisecond: 0,
            microsecond: 0,
          )
          .difference(dt)
          .inSeconds,
    ),
  );
}

/// Time of day extensions
extension TimeOfDayX on TimeOfDay {
  /// adds extra zero to the hour if required
  String get hourWithLeadingZero {
    return hour < 10 ? '0$hour' : '$hour';
  }

  /// adds extra zero to the minute if required
  String get minuteWithLeadingZero {
    return minute < 10 ? '0$minute' : '$minute';
  }

  /// representation of timeOfDay in HHmm format. e.g 09:05
  String get formatHHmm => '$hourWithLeadingZero:$minuteWithLeadingZero';

  /// A method that returns a DateTime object with the current date and the
  /// time of day
  DateTime toDtNow() {
    return DateTime.now().copyWith(hour: hour, minute: minute);
  }
}
