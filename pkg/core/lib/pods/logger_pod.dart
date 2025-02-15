import 'package:core/logger/logger_base.dart';
import 'package:core/logger/logger_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_pod.g.dart';

/// Logger pod
@Riverpod(keepAlive: true)
LoggerBase logger(Ref ref) {
  final isIos = defaultTargetPlatform == TargetPlatform.iOS;
  final printer = isIos
      ? PrefixPrinter(
          PrettyPrinter(
            lineLength: 80,
            colors: false,
          ),
        )
      : PrettyPrinter(
          lineLength: 80,
          printTime: true,
        );

  final logger = LoggerImpl(
    logger: Logger(
      printer: HybridPrinter(
        printer,
        debug: SimplePrinter(colors: !isIos),
      ),
    ),
  );

  return logger;
}
