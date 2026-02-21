// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_facade_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
///

@ProviderFor(authFacade)
final authFacadePod = AuthFacadeProvider._();

///

final class AuthFacadeProvider
    extends $FunctionalProvider<AuthFacade, AuthFacade, AuthFacade>
    with $Provider<AuthFacade> {
  ///
  AuthFacadeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authFacadePod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authFacadeHash();

  @$internal
  @override
  $ProviderElement<AuthFacade> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthFacade create(Ref ref) {
    return authFacade(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthFacade value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthFacade>(value),
    );
  }
}

String _$authFacadeHash() => r'dc96f2ed6b0af6d0e46b891390e6cbaf0d53ba33';

@ProviderFor(firebaseAuth)
final firebaseAuthPod = FirebaseAuthProvider._();

final class FirebaseAuthProvider
    extends $FunctionalProvider<FirebaseAuth, FirebaseAuth, FirebaseAuth>
    with $Provider<FirebaseAuth> {
  FirebaseAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAuthPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAuthHash();

  @$internal
  @override
  $ProviderElement<FirebaseAuth> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseAuth create(Ref ref) {
    return firebaseAuth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAuth value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAuth>(value),
    );
  }
}

String _$firebaseAuthHash() => r'cb440927c3ab863427fd4b052a8ccba4c024c863';
