// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logger_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Logger pod

@ProviderFor(logger)
final loggerPod = LoggerProvider._();

/// Logger pod

final class LoggerProvider
    extends $FunctionalProvider<LoggerBase, LoggerBase, LoggerBase>
    with $Provider<LoggerBase> {
  /// Logger pod
  LoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loggerPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loggerHash();

  @$internal
  @override
  $ProviderElement<LoggerBase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoggerBase create(Ref ref) {
    return logger(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoggerBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoggerBase>(value),
    );
  }
}

String _$loggerHash() => r'9fb86b5374d690f708313d1b9504b4bbdaaddc3a';
