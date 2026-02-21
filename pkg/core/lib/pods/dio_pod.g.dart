// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keep the pod singleton

@ProviderFor(cancelToken)
final cancelTokenPod = CancelTokenProvider._();

/// Keep the pod singleton

final class CancelTokenProvider
    extends $FunctionalProvider<CancelToken, CancelToken, CancelToken>
    with $Provider<CancelToken> {
  /// Keep the pod singleton
  CancelTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cancelTokenPod',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cancelTokenHash();

  @$internal
  @override
  $ProviderElement<CancelToken> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CancelToken create(Ref ref) {
    return cancelToken(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CancelToken value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CancelToken>(value),
    );
  }
}

String _$cancelTokenHash() => r'f52bec7e869dea808949c38ee8608cf104babf51';

/// The default dio http client

@ProviderFor(dio)
final dioPod = DioFamily._();

/// The default dio http client

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// The default dio http client
  DioProvider._({required DioFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'dioPod',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @override
  String toString() {
    return r'dioPod'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    final argument = this.argument as String;
    return dio(ref, baseUrl: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DioProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dioHash() => r'de6ccca6bcbed4c29d18d50a6268d6783dd41e93';

/// The default dio http client

final class DioFamily extends $Family
    with $FunctionalFamilyOverride<Dio, String> {
  DioFamily._()
    : super(
        retry: null,
        name: r'dioPod',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The default dio http client

  DioProvider call({required String baseUrl}) =>
      DioProvider._(argument: baseUrl, from: this);

  @override
  String toString() => r'dioPod';
}

/// The dio http client used only for retrying the call inside interceptor

@ProviderFor(dioRetry)
final dioRetryPod = DioRetryFamily._();

/// The dio http client used only for retrying the call inside interceptor

final class DioRetryProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// The dio http client used only for retrying the call inside interceptor
  DioRetryProvider._({
    required DioRetryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dioRetryPod',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dioRetryHash();

  @override
  String toString() {
    return r'dioRetryPod'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    final argument = this.argument as String;
    return dioRetry(ref, baseUrl: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DioRetryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dioRetryHash() => r'3a6b76ad6510818d7c7fe4e34fbc2c1006e601fd';

/// The dio http client used only for retrying the call inside interceptor

final class DioRetryFamily extends $Family
    with $FunctionalFamilyOverride<Dio, String> {
  DioRetryFamily._()
    : super(
        retry: null,
        name: r'dioRetryPod',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The dio http client used only for retrying the call inside interceptor

  DioRetryProvider call({required String baseUrl}) =>
      DioRetryProvider._(argument: baseUrl, from: this);

  @override
  String toString() => r'dioRetryPod';
}

/// The dio http client used only for making token requests

@ProviderFor(dioToken)
final dioTokenPod = DioTokenFamily._();

/// The dio http client used only for making token requests

final class DioTokenProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// The dio http client used only for making token requests
  DioTokenProvider._({
    required DioTokenFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dioTokenPod',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dioTokenHash();

  @override
  String toString() {
    return r'dioTokenPod'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    final argument = this.argument as String;
    return dioToken(ref, baseUrl: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DioTokenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dioTokenHash() => r'e6b44dee0d2469ce6b32f255c73172812942881c';

/// The dio http client used only for making token requests

final class DioTokenFamily extends $Family
    with $FunctionalFamilyOverride<Dio, String> {
  DioTokenFamily._()
    : super(
        retry: null,
        name: r'dioTokenPod',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The dio http client used only for making token requests

  DioTokenProvider call({required String baseUrl}) =>
      DioTokenProvider._(argument: baseUrl, from: this);

  @override
  String toString() => r'dioTokenPod';
}
