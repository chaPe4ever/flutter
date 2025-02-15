import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

///
final class FlavorHelper {
  /// Ctr
  const FlavorHelper._();

  // Fields
  static late FlavorEnum _currentFlavor;

  ///
  // Getters
  static FlavorEnum get currentFlavor => _currentFlavor;

  // Methods

  /// Initialise the flavor of the app.
  ///
  /// ***[testFlavorEnum]*** can be set and used only for test in order to
  /// ignore setting app flavor during launching of the app.
  static Future<Either<CoreException, FlavorEnum>> init({
    FlavorEnum? testFlavorEnum,
  }) async {
    try {
      if (testFlavorEnum != null) {
        return right(testFlavorEnum);
      }

      String? flavor;

      if (kIsWeb || Platform.isWindows) {
        flavor = const String.fromEnvironment('flavor');
      } else {
        flavor = await const MethodChannel(
          'flavor',
        ).invokeMethod<String>('getFlavor');
      }

      if (flavor == null || flavor.isEmpty) {
        return left(
          UnInitialisedFlavorException(
            innerMessage:
                'The flavor found null or empty. Check again the configuration',
          ),
        );
      }

      if (flavor == 'prod') {
        _currentFlavor = FlavorEnum.prod;
      } else if (flavor == 'stg') {
        _currentFlavor = FlavorEnum.stg;
      } else if (flavor == 'dev') {
        _currentFlavor = FlavorEnum.dev;
      } else {
        return left(
          UnInitialisedFlavorException(
            innerMessage:
                "The flavor: $flavor hasn't been defined or one "
                "of onProd onStg onDev callback arguments haven't been used",
          ),
        );
      }
      return right(_currentFlavor);
    } catch (e, st) {
      return left(UnInitialisedFlavorException(innerError: e, st: st));
    }
  }
}
