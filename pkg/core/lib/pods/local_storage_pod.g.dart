// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localStorageHash() => r'd307670e7d021c789781302b1e69b085331d2c91';

/// Local storage pod that provides storage functionality
///
/// Copied from [LocalStorage].
@ProviderFor(LocalStorage)
final localStoragePod =
    AutoDisposeNotifierProvider<LocalStorage, LocalStorageBase>.internal(
      LocalStorage.new,
      name: r'localStoragePod',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$localStorageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LocalStorage = AutoDisposeNotifier<LocalStorageBase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
