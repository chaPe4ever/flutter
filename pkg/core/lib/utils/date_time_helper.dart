import 'package:core/core.dart';
import 'package:core/utils/tz_helper.dart';
import 'package:flutter/material.dart';

/// Date time helper class
final class DtHelper {
  /// Private ctr
  DtHelper._();

  /// Parse the time string to time of day object
  static TimeOfDay parseTimeStr(String timeString) {
    final hours = int.parse(timeString.split(':')[0]);
    final minutes = int.parse(timeString.split(':')[1]);
    return TimeOfDay(hour: hours, minute: minutes);
  }

  /// Given the Utc string convert it to location timezone time of day
  static TimeOfDay? utcStrToLocationTzTimeOfDay(
    String utcTimeString, {
    required String tzLocationName,
  }) {
    // Parse the string to TimeOfDay
    final utcTime = parseTimeStr(utcTimeString);

    // Convert utc to location time-zone TimeOfDay
    return utcTimeOfDayToLocationTz(utcTime, tzLocationName: tzLocationName);
  }

  /// Given a UTC time of day convert it to location time zone time of day
  static TimeOfDay? utcTimeOfDayToLocationTz(
    TimeOfDay utcTime, {
    required String tzLocationName,
  }) {
    final dtNow = TzHelper.now(tzLocationName);
    if (dtNow == null) {
      return null;
    }
    final utcDt = DateTime.utc(
      dtNow.year,
      dtNow.month,
      dtNow.day,
      utcTime.hour,
      utcTime.minute,
    );
    final locationTzDt = TzHelper.from(utcDt, tzLocationName: tzLocationName);
    if (locationTzDt == null) {
      return null;
    }
    return TimeOfDay(hour: locationTzDt.hour, minute: locationTzDt.minute);
  }
}
