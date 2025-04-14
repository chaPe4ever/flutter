// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localStorageHash() => r'62a6fb44e3f5e67a877693955bd03c921b3115d0';

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

abstract class _$LocalStorage extends BuildlessAsyncNotifier<LocalStorageBase> {
  late final StorageType type;

  FutureOr<LocalStorageBase> build({
    required StorageType type,
  });
}

/// Local storage pod that provides storage functionality
///
/// Copied from [LocalStorage].
@ProviderFor(LocalStorage)
const localStoragePod = LocalStorageFamily();

/// Local storage pod that provides storage functionality
///
/// Copied from [LocalStorage].
class LocalStorageFamily extends Family<AsyncValue<LocalStorageBase>> {
  /// Local storage pod that provides storage functionality
  ///
  /// Copied from [LocalStorage].
  const LocalStorageFamily();

  /// Local storage pod that provides storage functionality
  ///
  /// Copied from [LocalStorage].
  LocalStorageProvider call({
    required StorageType type,
  }) {
    return LocalStorageProvider(
      type: type,
    );
  }

  @override
  LocalStorageProvider getProviderOverride(
    covariant LocalStorageProvider provider,
  ) {
    return call(
      type: provider.type,
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
  String? get name => r'localStoragePod';
}

/// Local storage pod that provides storage functionality
///
/// Copied from [LocalStorage].
class LocalStorageProvider
    extends AsyncNotifierProviderImpl<LocalStorage, LocalStorageBase> {
  /// Local storage pod that provides storage functionality
  ///
  /// Copied from [LocalStorage].
  LocalStorageProvider({
    required StorageType type,
  }) : this._internal(
          () => LocalStorage()..type = type,
          from: localStoragePod,
          name: r'localStoragePod',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$localStorageHash,
          dependencies: LocalStorageFamily._dependencies,
          allTransitiveDependencies:
              LocalStorageFamily._allTransitiveDependencies,
          type: type,
        );

  LocalStorageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final StorageType type;

  @override
  FutureOr<LocalStorageBase> runNotifierBuild(
    covariant LocalStorage notifier,
  ) {
    return notifier.build(
      type: type,
    );
  }

  @override
  Override overrideWith(LocalStorage Function() create) {
    return ProviderOverride(
      origin: this,
      override: LocalStorageProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<LocalStorage, LocalStorageBase> createElement() {
    return _LocalStorageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocalStorageProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LocalStorageRef on AsyncNotifierProviderRef<LocalStorageBase> {
  /// The parameter `type` of this provider.
  StorageType get type;
}

class _LocalStorageProviderElement
    extends AsyncNotifierProviderElement<LocalStorage, LocalStorageBase>
    with LocalStorageRef {
  _LocalStorageProviderElement(super.provider);

  @override
  StorageType get type => (origin as LocalStorageProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
