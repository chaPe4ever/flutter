import 'dart:developer' as developer;

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

enum Logs {
  api,
  signal,
  goRouter,
  analytics,
  push,
  riverpod;

  bool get isEnabled {
    switch (this) {
      case Logs.api:
        return false;
      case Logs.signal:
        return false;
      case Logs.goRouter:
        return false;
      case Logs.analytics:
        return false;
      case Logs.push:
        return false;
      case Logs.riverpod:
        return kDebugMode;
    }
  }
}

// ignore_for_file: unused_field
enum _Logger {
  black('30'),
  red('31'),
  green('32'),
  yellow('33'),
  blue('34'),
  magenta('35'),
  cyan('36'),
  white('37');

  const _Logger(this.code);
  final String code;

  void log(dynamic text, {String name = 'App'}) =>
      developer.log('\x1B[${code}m$text\x1B[0m', name: name);
}

class Log {
  static void error(Object error, {StackTrace? st}) {
    _Logger.red.log(error);
    _Logger.red.log(st);
  }

  static void analytics(String text) {
    if (Logs.analytics.isEnabled) {
      _Logger.yellow.log(text, name: Logs.analytics.name);
    }
  }

  static void info(String text) {
    _Logger.cyan.log(text);
  }

  static void warning(String text) {
    _Logger.yellow.log(text);
  }

  static void api(String text) {
    if (Logs.api.isEnabled) {
      _Logger.blue.log(text, name: Logs.api.name);
    }
  }

  static void push(String text) {
    if (Logs.push.isEnabled) {
      _Logger.green.log(text, name: Logs.push.name);
    }
  }

  static void riverpod({
    String? providerName,
    String? info,
    Object? error,
    String? Function({required bool isActive})? verboseCb,
  }) {
    if (Logs.riverpod.isEnabled) {
      if (providerName != null) {
        _Logger.white.log(providerName, name: Logs.riverpod.name);
      }
      if (error != null) {
        _Logger.red.log(error, name: Logs.riverpod.name);
      }
      if (info != null) {
        _Logger.blue.log(info, name: Logs.riverpod.name);
      }
      if (verboseCb != null) {
        final log = verboseCb(isActive: false);
        if (log != null && log.isNotEmpty) {
          _Logger.cyan.log(log, name: Logs.riverpod.name);
        }
      }
    }
  }
}

class SignalsLogger extends LoggingSignalsObserver {
  @override
  void log(String message) {
    if (Logs.signal.isEnabled) {
      _Logger.magenta.log(message, name: 'signals');
    }
  }
}

class RiverpodLogger extends ProviderObserver {
  const RiverpodLogger();
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (newValue is AsyncError) {
      final error = newValue.error;
      if (error is CoreException) {
        if (error is ClientVisibleException) {
          // Decide if you want to log something for this special failure
        } else {
          Log.riverpod(error: error.prefix ?? '$error\n${error.st}\n');
        }
      } else {
        Log.riverpod(error: error);
      }
    }

    Log.riverpod(
      providerName: 'Provider: ${provider.name ?? provider.runtimeType}',
    );
    Log.riverpod(
      info: 'previousValueType: ${previousValue.runtimeType}',
      verboseCb: ({required bool isActive}) {
        if (isActive) {
          return 'previousValue: $previousValue';
        }
        return null;
      },
    );
    Log.riverpod(
      info: 'newValueType: ${newValue.runtimeType}',
      verboseCb: ({required bool isActive}) {
        if (isActive) {
          return 'newValue: $previousValue';
        }
        return null;
      },
    );
  }
}

extension PrettyDioLoggerExtension on PrettyDioLogger {
  static PrettyDioLogger get logger {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      maxWidth: 80,
      logPrint: (o) => Log.api(o.toString()),
    );
  }
}
