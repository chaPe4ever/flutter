import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Lock the orientations you want your device to have.
/// It requires to write code in iOS plarform in order to work
class OrientationHelper {
  // Fields
  static const _platform = MethodChannel('game_room/orientation');

  ///
  // Methods
  static Future<Option<CoreException>> setOrientation({
    required List<DeviceOrientation> orientations,
  }) async {
    try {
      assert(
        orientations.isNotEmpty,
        'The The orientation list cannot be empty',
      );
      if (orientations.isEmpty) {
        return some(
          UnknownCoreException(),
        );
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
                DeviceOrientation.landscapeRight,
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
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitAllLandscapeRight',
            );
          } else if ([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitAllLandscapeLeft',
            );
          } else if ([
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitUpLandscapeAll',
            );
          } else if ([
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitDownLandscapeAll',
            );
          } else if ([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'landscapeAll',
            );
          } else if ([
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeRight,
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitAll',
            );
          } else if ([
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeRight,
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitDownLandscapeRight',
            );
          } else if ([
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeLeft,
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitUpLandscapeLeft',
            );
          } else if ([
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitDownLandscapeLeft',
            );
          } else if ([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitAll',
            );
          } else if ([
            DeviceOrientation.portraitUp,
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitUp',
            );
          } else if ([
            DeviceOrientation.portraitDown,
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'portraitDown',
            );
          } else if ([
            DeviceOrientation.landscapeRight,
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'landscapeRight',
            );
          } else if ([
            DeviceOrientation.landscapeLeft,
          ].every(
            (item) => orientations.toSet().contains(item),
          )) {
            await _platform.invokeMethod(
              'setOrientation',
              'landscapeLeft',
            );
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
    } on PlatformException catch (e) {
      return some(
        UnknownCoreException(
          innerMessage: kDebugMode ? e.message : null,
        ),
      );
    } catch (e) {
      return some(
        UnknownCoreException(
          innerMessage: kDebugMode ? e.toString() : null,
        ),
      );
    }
  }
}
