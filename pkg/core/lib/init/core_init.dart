import 'dart:async';

import 'package:core/configs/app_config.dart';
import 'package:core/exceptions/core_exception.dart';
import 'package:core/exceptions/core_exceptions.dart';
import 'package:core/logger/logger_base.dart';
import 'package:core/network/network_base.dart';
import 'package:core/pods/logger_pod.dart';
import 'package:core/pods/network_pod.dart';
import 'package:core/storage/local_storage_base.dart';
import 'package:core/theme/theme_base.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Core dependency injection interface
final class Core {
  /// Make sure you don't add elements on both [overrides] and param list:
  /// [networkBase], [localStorageBase], [themeBase] as well as both on
  /// [observers] and param: [loggerBase]. Doing so, will lead to duplicates
  /// on the overrides and observers list
  static Future<Either<CoreException, ProviderContainer>> init({
    required ThemeBase themeBase,
    List<Override>? overrides,
    List<ProviderObserver>? observers,
    AppConfig? appConfig,
    NetworkBase? networkBase,
    LocalStorageBase? localStorageBase,
    LoggerBase? loggerBase,
    FutureOr<void> Function(ProviderContainer container)? onPostInit,
  }) async {
    overrides ??= List.empty(growable: true);
    observers ??= List.empty(growable: true);

    if (loggerBase != null) {
      overrides.add(loggerPod.overrideWithValue(loggerBase));
    }

    if (networkBase != null) {
      overrides.add(networkPod.overrideWithValue(networkBase));
    }

    final container = ProviderContainer(
      overrides: overrides,
      observers: observers,
    );

    try {
      await EasyLocalization.ensureInitialized();

      if (appConfig != null) {
        await appConfig.init();
      }

      await onPostInit?.call(container);

      return right(container);
    } on CoreException catch (e) {
      container.read(loggerPod).e(e.messageKey, e: e, st: e.st);
      return left(e);
    } catch (e, st) {
      final error = UnknownCoreException(innerError: e, st: st);
      container.read(loggerPod).e(error.messageKey, e: error, st: error.st);
      return left(error);
    }
  }
}
