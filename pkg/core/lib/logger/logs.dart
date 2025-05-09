import 'dart:developer' as developer;

import 'package:core/core.dart';

enum Logs {
  api,
  signal,
  goRouter,
  analytics,
  push,
  info,
  warning,
  riverpod,
  error;

  // Setter to enable/disable individual logs
  set enabled(bool value) {
    switch (this) {
      case Logs.api:
        _apiEnabled = value;
      case Logs.signal:
        _signalEnabled = value;
      case Logs.goRouter:
        _goRouterEnabled = value;
      case Logs.analytics:
        _analyticsEnabled = value;
      case Logs.push:
        _pushEnabled = value;
      case Logs.riverpod:
        _riverpodEnabled = value;
      case Logs.error:
        _errorEnabled = value;
      case Logs.info:
        _infoEnabled = value;
      case Logs.warning:
        _warningEnabled = value;
    }
  }

  // Static method to enable multiple logs at once
  static void enable(List<Logs> logs) {
    for (final log in logs) {
      log.enabled = true;
    }
  }

  // Static method to disable multiple logs at once
  static void disable(List<Logs> logs) {
    for (final log in logs) {
      log.enabled = false;
    }
  }

  // Static fields to store the enabled state
  static bool _apiEnabled = false;
  static bool _signalEnabled = false;
  static bool _goRouterEnabled = false;
  static bool _analyticsEnabled = false;
  static bool _pushEnabled = false;
  static bool _riverpodEnabled = false;
  static bool _errorEnabled = false;
  static bool _infoEnabled = false;
  static bool _warningEnabled = false;

  // Override the isEnabled getter to use the static fields
  bool get isEnabled {
    switch (this) {
      case Logs.api:
        return _apiEnabled;
      case Logs.signal:
        return _signalEnabled;
      case Logs.goRouter:
        return _goRouterEnabled;
      case Logs.analytics:
        return _analyticsEnabled;
      case Logs.push:
        return _pushEnabled;
      case Logs.riverpod:
        return _riverpodEnabled;
      case Logs.error:
        return _errorEnabled;
      case Logs.info:
        return _infoEnabled;
      case Logs.warning:
        return _warningEnabled;
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
    if (Logs.error.isEnabled) {
      _Logger.red.log(error);
      _Logger.red.log(st);
    }
  }

  static void analytics(String text) {
    if (Logs.analytics.isEnabled) {
      _Logger.yellow.log(text, name: Logs.analytics.name);
    }
  }

  static void info(String text) {
    if (Logs.info.isEnabled) {
      _Logger.cyan.log(text);
    }
  }

  static void warning(String text) {
    if (Logs.warning.isEnabled) {
      _Logger.yellow.log(text);
    }
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
