// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pretty_dio_logger_interceptor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(prettyDioLoggerInterceptor)
final prettyDioLoggerInterceptorPod = PrettyDioLoggerInterceptorProvider._();

final class PrettyDioLoggerInterceptorProvider
    extends
        $FunctionalProvider<PrettyDioLogger, PrettyDioLogger, PrettyDioLogger>
    with $Provider<PrettyDioLogger> {
  PrettyDioLoggerInterceptorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prettyDioLoggerInterceptorPod',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prettyDioLoggerInterceptorHash();

  @$internal
  @override
  $ProviderElement<PrettyDioLogger> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrettyDioLogger create(Ref ref) {
    return prettyDioLoggerInterceptor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrettyDioLogger value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrettyDioLogger>(value),
    );
  }
}

String _$prettyDioLoggerInterceptorHash() =>
    r'c71dc4aa11aab3c211a1f96450a5b5c4d23ca864';
