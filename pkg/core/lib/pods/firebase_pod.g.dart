// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keep the pod singleton

@ProviderFor(firestore)
final firestorePod = FirestoreProvider._();

/// Keep the pod singleton

final class FirestoreProvider
    extends
        $FunctionalProvider<
          FirebaseFirestore,
          FirebaseFirestore,
          FirebaseFirestore
        >
    with $Provider<FirebaseFirestore> {
  /// Keep the pod singleton
  FirestoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firestorePod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firestoreHash();

  @$internal
  @override
  $ProviderElement<FirebaseFirestore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseFirestore create(Ref ref) {
    return firestore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseFirestore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseFirestore>(value),
    );
  }
}

String _$firestoreHash() => r'ea545ab322745f4c35e7f3eade2beca7dd8e0b85';

/// Keep the pod singleton

@ProviderFor(functions)
final functionsPod = FunctionsFamily._();

/// Keep the pod singleton

final class FunctionsProvider
    extends
        $FunctionalProvider<
          FirebaseFunctions,
          FirebaseFunctions,
          FirebaseFunctions
        >
    with $Provider<FirebaseFunctions> {
  /// Keep the pod singleton
  FunctionsProvider._({
    required FunctionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'functionsPod',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$functionsHash();

  @override
  String toString() {
    return r'functionsPod'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<FirebaseFunctions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseFunctions create(Ref ref) {
    final argument = this.argument as String;
    return functions(ref, region: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseFunctions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseFunctions>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FunctionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$functionsHash() => r'a2dae6af90be9cac3b601637cfd5e8200f29b171';

/// Keep the pod singleton

final class FunctionsFamily extends $Family
    with $FunctionalFamilyOverride<FirebaseFunctions, String> {
  FunctionsFamily._()
    : super(
        retry: null,
        name: r'functionsPod',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Keep the pod singleton

  FunctionsProvider call({String region = 'europe-west3'}) =>
      FunctionsProvider._(argument: region, from: this);

  @override
  String toString() => r'functionsPod';
}

/// Keep the pod singleton

@ProviderFor(firebaseDb)
final firebaseDbPod = FirebaseDbProvider._();

/// Keep the pod singleton

final class FirebaseDbProvider
    extends
        $FunctionalProvider<
          FirebaseDatabase,
          FirebaseDatabase,
          FirebaseDatabase
        >
    with $Provider<FirebaseDatabase> {
  /// Keep the pod singleton
  FirebaseDbProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseDbPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseDbHash();

  @$internal
  @override
  $ProviderElement<FirebaseDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseDatabase create(Ref ref) {
    return firebaseDb(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseDatabase>(value),
    );
  }
}

String _$firebaseDbHash() => r'737e827007fc303773f8048e130da8adf247dbf7';
