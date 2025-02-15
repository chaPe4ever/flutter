// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cancelTokenHash() => r'f52bec7e869dea808949c38ee8608cf104babf51';

/// Keep the pod singleton
///
/// Copied from [cancelToken].
@ProviderFor(cancelToken)
final cancelTokenPod = AutoDisposeProvider<CancelToken>.internal(
  cancelToken,
  name: r'cancelTokenPod',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cancelTokenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CancelTokenRef = AutoDisposeProviderRef<CancelToken>;
String _$dioHash() => r'de6ccca6bcbed4c29d18d50a6268d6783dd41e93';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// The default dio http client
///
/// Copied from [dio].
@ProviderFor(dio)
const dioPod = DioFamily();

/// The default dio http client
///
/// Copied from [dio].
class DioFamily extends Family<Dio> {
  /// The default dio http client
  ///
  /// Copied from [dio].
  const DioFamily();

  /// The default dio http client
  ///
  /// Copied from [dio].
  DioProvider call({
    required String baseUrl,
  }) {
    return DioProvider(
      baseUrl: baseUrl,
    );
  }

  @override
  DioProvider getProviderOverride(
    covariant DioProvider provider,
  ) {
    return call(
      baseUrl: provider.baseUrl,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dioPod';
}

/// The default dio http client
///
/// Copied from [dio].
class DioProvider extends AutoDisposeProvider<Dio> {
  /// The default dio http client
  ///
  /// Copied from [dio].
  DioProvider({
    required String baseUrl,
  }) : this._internal(
          (ref) => dio(
            ref as DioRef,
            baseUrl: baseUrl,
          ),
          from: dioPod,
          name: r'dioPod',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$dioHash,
          dependencies: DioFamily._dependencies,
          allTransitiveDependencies: DioFamily._allTransitiveDependencies,
          baseUrl: baseUrl,
        );

  DioProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.baseUrl,
  }) : super.internal();

  final String baseUrl;

  @override
  Override overrideWith(
    Dio Function(DioRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DioProvider._internal(
        (ref) => create(ref as DioRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        baseUrl: baseUrl,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Dio> createElement() {
    return _DioProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DioProvider && other.baseUrl == baseUrl;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, baseUrl.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DioRef on AutoDisposeProviderRef<Dio> {
  /// The parameter `baseUrl` of this provider.
  String get baseUrl;
}

class _DioProviderElement extends AutoDisposeProviderElement<Dio> with DioRef {
  _DioProviderElement(super.provider);

  @override
  String get baseUrl => (origin as DioProvider).baseUrl;
}

String _$dioRetryHash() => r'3a6b76ad6510818d7c7fe4e34fbc2c1006e601fd';

/// The dio http client used only for retrying the call inside interceptor
///
/// Copied from [dioRetry].
@ProviderFor(dioRetry)
const dioRetryPod = DioRetryFamily();

/// The dio http client used only for retrying the call inside interceptor
///
/// Copied from [dioRetry].
class DioRetryFamily extends Family<Dio> {
  /// The dio http client used only for retrying the call inside interceptor
  ///
  /// Copied from [dioRetry].
  const DioRetryFamily();

  /// The dio http client used only for retrying the call inside interceptor
  ///
  /// Copied from [dioRetry].
  DioRetryProvider call({
    required String baseUrl,
  }) {
    return DioRetryProvider(
      baseUrl: baseUrl,
    );
  }

  @override
  DioRetryProvider getProviderOverride(
    covariant DioRetryProvider provider,
  ) {
    return call(
      baseUrl: provider.baseUrl,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dioRetryPod';
}

/// The dio http client used only for retrying the call inside interceptor
///
/// Copied from [dioRetry].
class DioRetryProvider extends AutoDisposeProvider<Dio> {
  /// The dio http client used only for retrying the call inside interceptor
  ///
  /// Copied from [dioRetry].
  DioRetryProvider({
    required String baseUrl,
  }) : this._internal(
          (ref) => dioRetry(
            ref as DioRetryRef,
            baseUrl: baseUrl,
          ),
          from: dioRetryPod,
          name: r'dioRetryPod',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dioRetryHash,
          dependencies: DioRetryFamily._dependencies,
          allTransitiveDependencies: DioRetryFamily._allTransitiveDependencies,
          baseUrl: baseUrl,
        );

  DioRetryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.baseUrl,
  }) : super.internal();

  final String baseUrl;

  @override
  Override overrideWith(
    Dio Function(DioRetryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DioRetryProvider._internal(
        (ref) => create(ref as DioRetryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        baseUrl: baseUrl,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Dio> createElement() {
    return _DioRetryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DioRetryProvider && other.baseUrl == baseUrl;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, baseUrl.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DioRetryRef on AutoDisposeProviderRef<Dio> {
  /// The parameter `baseUrl` of this provider.
  String get baseUrl;
}

class _DioRetryProviderElement extends AutoDisposeProviderElement<Dio>
    with DioRetryRef {
  _DioRetryProviderElement(super.provider);

  @override
  String get baseUrl => (origin as DioRetryProvider).baseUrl;
}

String _$dioTokenHash() => r'e6b44dee0d2469ce6b32f255c73172812942881c';

/// The dio http client used only for making token requests
///
/// Copied from [dioToken].
@ProviderFor(dioToken)
const dioTokenPod = DioTokenFamily();

/// The dio http client used only for making token requests
///
/// Copied from [dioToken].
class DioTokenFamily extends Family<Dio> {
  /// The dio http client used only for making token requests
  ///
  /// Copied from [dioToken].
  const DioTokenFamily();

  /// The dio http client used only for making token requests
  ///
  /// Copied from [dioToken].
  DioTokenProvider call({
    required String baseUrl,
  }) {
    return DioTokenProvider(
      baseUrl: baseUrl,
    );
  }

  @override
  DioTokenProvider getProviderOverride(
    covariant DioTokenProvider provider,
  ) {
    return call(
      baseUrl: provider.baseUrl,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dioTokenPod';
}

/// The dio http client used only for making token requests
///
/// Copied from [dioToken].
class DioTokenProvider extends AutoDisposeProvider<Dio> {
  /// The dio http client used only for making token requests
  ///
  /// Copied from [dioToken].
  DioTokenProvider({
    required String baseUrl,
  }) : this._internal(
          (ref) => dioToken(
            ref as DioTokenRef,
            baseUrl: baseUrl,
          ),
          from: dioTokenPod,
          name: r'dioTokenPod',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dioTokenHash,
          dependencies: DioTokenFamily._dependencies,
          allTransitiveDependencies: DioTokenFamily._allTransitiveDependencies,
          baseUrl: baseUrl,
        );

  DioTokenProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.baseUrl,
  }) : super.internal();

  final String baseUrl;

  @override
  Override overrideWith(
    Dio Function(DioTokenRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DioTokenProvider._internal(
        (ref) => create(ref as DioTokenRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        baseUrl: baseUrl,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Dio> createElement() {
    return _DioTokenProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DioTokenProvider && other.baseUrl == baseUrl;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, baseUrl.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DioTokenRef on AutoDisposeProviderRef<Dio> {
  /// The parameter `baseUrl` of this provider.
  String get baseUrl;
}

class _DioTokenProviderElement extends AutoDisposeProviderElement<Dio>
    with DioTokenRef {
  _DioTokenProviderElement(super.provider);

  @override
  String get baseUrl => (origin as DioTokenProvider).baseUrl;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
