// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Local storage pod that provides storage functionality

@ProviderFor(LocalStorage)
final localStoragePod = LocalStorageProvider._();

/// Local storage pod that provides storage functionality
final class LocalStorageProvider
    extends $NotifierProvider<LocalStorage, LocalStorageBase> {
  /// Local storage pod that provides storage functionality
  LocalStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localStoragePod',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localStorageHash();

  @$internal
  @override
  LocalStorage create() => LocalStorage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalStorageBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalStorageBase>(value),
    );
  }
}

String _$localStorageHash() => r'd307670e7d021c789781302b1e69b085331d2c91';

/// Local storage pod that provides storage functionality

abstract class _$LocalStorage extends $Notifier<LocalStorageBase> {
  LocalStorageBase build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LocalStorageBase, LocalStorageBase>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LocalStorageBase, LocalStorageBase>,
              LocalStorageBase,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
