import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

/// Time zone helper class
final class TzHelper {
  TzHelper._();

  static tz.Location? _tzLocation;

  /// Init once at the app start
  static Future<void> init() async {
    tz.initializeTimeZones();
  }

  /// Get the datTime.now based on the preferred timezone [tzLocationName]
  static DateTime? now(String tzLocationName) => _tryCatchSetLocation(
        () => tz.TZDateTime.now(_tzLocation!),
        tzLocationName: tzLocationName,
      );

  /// EitherNow can be called from Widgets and requires to pass the [ref] so
  /// that we can log any potential error to crashlytics. In case we don't
  /// pass the [ref] we can't log the error to crashlytics and it's only
  /// being logged to console.
  /// The [tzLocationName] is required in order to get the datetime.Now based
  /// on the timezone location name.
  /// The return type is an either and can be unfolded to handle the
  /// potential error.
  static Either<CoreException, DateTime> eitherNow({
    required String tzLocationName,
    WidgetRef? ref,
  }) {
    try {
      _setLocation(tzLocationName);
      final dtNow = tz.TZDateTime.now(_tzLocation!);
      return right(dtNow);
    } catch (ex, st) {
      final e = UnknownCoreException(
        innerMessage: switch (ex) {
          final TimeZoneInitException e => e.msg,
          final LocationNotFoundException e => e.msg,
          _ => null
        },
      );
      LoggerHelper.logError(e: e, st: st, ref: ref);

      return left(e);
    }
  }

  /// Get the dateTime in the preferred timezone [tzLocationName] given the
  /// [other]
  static DateTime? from(DateTime other, {required String tzLocationName}) =>
      _tryCatchSetLocation(
        () => tz.TZDateTime.from(other, _tzLocation!),
        tzLocationName: tzLocationName,
      );

  /// EitherNow can be called from Widgets and requires to pass the [ref] so
  /// that we can log any potential error to crashlytics. In case we don't
  /// pass the [ref] we can't log the error to crashlytics and it's only
  /// being logged to console.
  /// The [tzLocationName] is required in order to transform the [other]
  /// DateTime to that timezone location name.
  /// The return type is an either and can be unfolded to handle the
  /// potential error.
  static Either<CoreException, DateTime> eitherFrom({
    required DateTime other,
    required String tzLocationName,
    WidgetRef? ref,
  }) {
    try {
      _setLocation(tzLocationName);
      final dtNow = tz.TZDateTime.from(other, _tzLocation!);
      return right(dtNow);
    } catch (ex, st) {
      final e = UnknownCoreException(
        innerMessage: switch (ex) {
          final TimeZoneInitException e => e.msg,
          final LocationNotFoundException e => e.msg,
          _ => null
        },
      );
      LoggerHelper.logError(e: e, st: st, ref: ref);

      return left(e);
    }
  }

  /// Parse the [formattedString] in the preferred timezone [tzLocationName]
  static DateTime? parse(
    String formattedString, {
    required String tzLocationName,
  }) =>
      _tryCatchSetLocation(
        () => tz.TZDateTime.parse(_tzLocation!, formattedString),
        tzLocationName: tzLocationName,
      );

  /// EitherParse can be called from Widgets and requires to pass the [ref] so
  /// that we can log any potential error to crashlytics. In case we don't
  /// pass the [ref] we can't log the error to crashlytics and it's only
  /// being logged to console.
  /// The [tzLocationName] is required in order to transform the
  /// [formattedString] to that timezone location name.
  /// The return type is an either and can be unfolded to handle the
  /// potential error.
  static Either<CoreException, DateTime> eitherParse({
    required String formattedString,
    required String tzLocationName,
    WidgetRef? ref,
  }) {
    try {
      _setLocation(tzLocationName);
      final dtNow = tz.TZDateTime.parse(_tzLocation!, formattedString);
      return right(dtNow);
    } catch (ex, st) {
      final e = UnknownCoreException(
        innerMessage: switch (ex) {
          final TimeZoneInitException e => e.msg,
          final LocationNotFoundException e => e.msg,
          _ => null
        },
      );
      LoggerHelper.logError(e: e, st: st, ref: ref);
      return left(e);
    }
  }

  /// Either check if the user's device timezone is in a different timezone
  /// given the [tzLocationName]
  static Future<Either<CoreException, bool>> isDeviceTzEqTo(
    String tzLocationName,
  ) async {
    try {
      _setLocation(tzLocationName);

      final deviceTimezone = await FlutterTimezone.getLocalTimezone();

      // Get the application's set local location (timezone)
      final appLocation = tz.local;

      // Check if the device timezone is same with the application's timezone
      final deviceTzMatchLocationTz = deviceTimezone == appLocation.name;

      return right(deviceTzMatchLocationTz);
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      return left(UnknownCoreException(innerError: e));
    }
  }

  /// Try catch block setting up the location and throwing if the location is
  /// not valid
  static T? _tryCatchSetLocation<T>(
    T Function() cb, {
    required String tzLocationName,
  }) {
    try {
      _setLocation(tzLocationName);
      return cb();
    } catch (_, st) {
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  /// Set the preferred timeZone [tzLocationName]
  static void _setLocation(String tzLocationName) {
    _tzLocation = tz.getLocation(tzLocationName);
    tz.setLocalLocation(_tzLocation!);
  }
}
