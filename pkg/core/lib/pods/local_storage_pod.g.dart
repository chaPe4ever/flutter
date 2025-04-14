// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localStorageHash() => r'597cbc0050da20ddf105157fa32c54bda28fa429';

/// Local storage pod that provides storage functionality
///
/// Copied from [LocalStorage].
@ProviderFor(LocalStorage)
final localStoragePod =
    AsyncNotifierProvider<LocalStorage, LocalStorageBase?>.internal(
  LocalStorage.new,
  name: r'localStoragePod',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$localStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocalStorage = AsyncNotifier<LocalStorageBase?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
