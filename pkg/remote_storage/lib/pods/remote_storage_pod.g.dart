// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_storage_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
///

@ProviderFor(remoteStorage)
final remoteStoragePod = RemoteStorageProvider._();

///

final class RemoteStorageProvider
    extends
        $FunctionalProvider<
          RemoteStorageBase,
          RemoteStorageBase,
          RemoteStorageBase
        >
    with $Provider<RemoteStorageBase> {
  ///
  RemoteStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteStoragePod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteStorageHash();

  @$internal
  @override
  $ProviderElement<RemoteStorageBase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RemoteStorageBase create(Ref ref) {
    return remoteStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteStorageBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteStorageBase>(value),
    );
  }
}

String _$remoteStorageHash() => r'9a9c031403626d8caa2e146624b15ce36cdea2da';

@ProviderFor(firebaseStorage)
final firebaseStoragePod = FirebaseStorageProvider._();

final class FirebaseStorageProvider
    extends
        $FunctionalProvider<FirebaseStorage, FirebaseStorage, FirebaseStorage>
    with $Provider<FirebaseStorage> {
  FirebaseStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseStoragePod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseStorageHash();

  @$internal
  @override
  $ProviderElement<FirebaseStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseStorage create(Ref ref) {
    return firebaseStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseStorage>(value),
    );
  }
}

String _$firebaseStorageHash() => r'8e9f5814f2e4871c92e546bca90dbeaf2f43edeb';
