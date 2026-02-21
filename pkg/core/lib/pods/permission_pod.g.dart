// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App permission pod

@ProviderFor(permission)
final permissionPod = PermissionProvider._();

/// App permission pod

final class PermissionProvider
    extends $FunctionalProvider<PermissionBase, PermissionBase, PermissionBase>
    with $Provider<PermissionBase> {
  /// App permission pod
  PermissionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionHash();

  @$internal
  @override
  $ProviderElement<PermissionBase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PermissionBase create(Ref ref) {
    return permission(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PermissionBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PermissionBase>(value),
    );
  }
}

String _$permissionHash() => r'1958ed36fc8f8c26314172ef7439b6813ff34456';
