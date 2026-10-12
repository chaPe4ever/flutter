import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Lock the orientations you want your device to have.
/// It requires to write code in iOS plarform in order to work
abstract class OrientationHelper {
  // Fields
  static late MethodChannel _platform;

  static void init({String channelName = 'core/orientation'}) {
    _platform = MethodChannel(channelName);
  }

  ///
  // Methods
  static Future<Option<CoreException>> setOrientation({
    required List<DeviceOrientation> orientations,
  }) async {
    try {
      if (orientations.isEmpty) {
        return some(UnknownCoreException());
      }
      if (defaultTargetPlatform case TargetPlatform.android) {
        await SystemChrome.setPreferredOrientations(
          orientations.toSet().toList(),
        );
      } else if (defaultTargetPlatform case TargetPlatform.iOS) {
        if (orientations.length == 1) {
          final _ = switch (orientations.first) {
            DeviceOrientation.portraitUp => await _platform.invokeMethod(
              'setOrientation',
              DeviceOrientation.portraitUp.name,
            ),
            DeviceOrientation.portraitDown => await _platform.invokeMethod(
              'setOrientation',
              DeviceOrientation.portraitDown.name,
            ),
            DeviceOrientation.landscapeLeft => await _platform.invokeMethod(
              'setOrientation',
              DeviceOrientation.landscapeLeft.name,
            ),
            DeviceOrientation.landscapeRight => await _platform.invokeMethod(
              'setOrientation',
              DeviceOrientation.landscapeRight.name,
            ),
          };
        } else {
          if (DeviceOrientation.values.every(
            (item) => orientations.toSet().toSet().contains(item),
          )) {
            await _platform.invokeMethod('setOrientation', 'all');
          } else if ([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeRight,
          ].every((item) => orientations.toSet().contains(item))) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitAllLandscapeRight',
            );
          } else if ([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
          ].every((item) => orientations.toSet().contains(item))) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitAllLandscapeLeft',
            );
          } else if ([
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ].every((item) => orientations.toSet().contains(item))) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitUpLandscapeAll',
            );
          } else if ([
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ].every((item) => orientations.toSet().contains(item))) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitDownLandscapeAll',
            );
          } else if ([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ].every((item) => orientations.toSet().contains(item))) {
            await _platform.invokeMethod('setOrientation', 'landscapeAll');
          } else if ([
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeRight,
          ].every((item) => orientations.toSet().contains(item))) {
            await _platform.invokeMethod('setOrientation', 'portraitAll');
          } else if ([
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeRight,
          ].every((item) => orientations.toSet().contains(item))) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitDownLandscapeRight',
            );
          } else if ([
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeLeft,
          ].every((item) => orientations.toSet().contains(item))) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitUpLandscapeLeft',
            );
          } else if ([
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
          ].every((item) => orientations.toSet().contains(item))) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitDownLandscapeLeft',
            );
          } else if ([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ].every((item) => orientations.toSet().contains(item))) {
            await _platform.invokeMethod('setOrientation', 'portraitAll');
          }
        }
      } else {
        return some(
          UnknownCoreException(
            innerMessage: kDebugMode
                ? 'The orientation is not supported '
                      'for the targetPlatform :$defaultTargetPlatform'
                : null,
          ),
        );
      }

      return none();
    } on Exception catch (e) {
      return some(
        UnknownCoreException(innerMessage: orientationExceptionMessage(e)),
      );
    }
  }
}

/// Maps orientation failures to user-visible inner messages.
String? orientationExceptionMessage(Exception e) {
  if (!kDebugMode) {
    return null;
  }
  return e is PlatformException ? e.message : e.toString();
}
