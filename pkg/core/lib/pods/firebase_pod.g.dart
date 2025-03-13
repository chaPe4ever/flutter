// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firestoreHash() => r'235f307656cd568658800cc3db03a73039aacc71';

/// Keep the pod singleton
///
/// Copied from [firestore].
@ProviderFor(firestore)
final firestorePod = Provider<FirebaseFirestore>.internal(
  firestore,
  name: r'firestorePod',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firestoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirestoreRef = ProviderRef<FirebaseFirestore>;
String _$functionsHash() => r'ca653b80ab5e6cdbd28dd377efe48a749bb5e060';

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

/// Keep the pod singleton
///
/// Copied from [functions].
@ProviderFor(functions)
const functionsPod = FunctionsFamily();

/// Keep the pod singleton
///
/// Copied from [functions].
class FunctionsFamily extends Family<FirebaseFunctions> {
  /// Keep the pod singleton
  ///
  /// Copied from [functions].
  const FunctionsFamily();

  /// Keep the pod singleton
  ///
  /// Copied from [functions].
  FunctionsProvider call({
    String region = 'europe-west3',
  }) {
    return FunctionsProvider(
      region: region,
    );
  }

  @override
  FunctionsProvider getProviderOverride(
    covariant FunctionsProvider provider,
  ) {
    return call(
      region: provider.region,
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
  String? get name => r'functionsPod';
}

/// Keep the pod singleton
///
/// Copied from [functions].
class FunctionsProvider extends Provider<FirebaseFunctions> {
  /// Keep the pod singleton
  ///
  /// Copied from [functions].
  FunctionsProvider({
    String region = 'europe-west3',
  }) : this._internal(
          (ref) => functions(
            ref as FunctionsRef,
            region: region,
          ),
          from: functionsPod,
          name: r'functionsPod',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$functionsHash,
          dependencies: FunctionsFamily._dependencies,
          allTransitiveDependencies: FunctionsFamily._allTransitiveDependencies,
          region: region,
        );

  FunctionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.region,
  }) : super.internal();

  final String region;

  @override
  Override overrideWith(
    FirebaseFunctions Function(FunctionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FunctionsProvider._internal(
        (ref) => create(ref as FunctionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        region: region,
      ),
    );
  }

  @override
  ProviderElement<FirebaseFunctions> createElement() {
    return _FunctionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FunctionsProvider && other.region == region;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, region.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FunctionsRef on ProviderRef<FirebaseFunctions> {
  /// The parameter `region` of this provider.
  String get region;
}

class _FunctionsProviderElement extends ProviderElement<FirebaseFunctions>
    with FunctionsRef {
  _FunctionsProviderElement(super.provider);

  @override
  String get region => (origin as FunctionsProvider).region;
}

String _$firebaseDbHash() => r'737e827007fc303773f8048e130da8adf247dbf7';

/// Keep the pod singleton
///
/// Copied from [firebaseDb].
@ProviderFor(firebaseDb)
final firebaseDbPod = Provider<FirebaseDatabase>.internal(
  firebaseDb,
  name: r'firebaseDbPod',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firebaseDbHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseDbRef = ProviderRef<FirebaseDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
