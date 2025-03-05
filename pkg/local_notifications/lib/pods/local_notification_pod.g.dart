// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_notification_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localNotificationsHash() =>
    r'4457d0fcfca416b41b3a4af74f1d04c203d682c2';

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

abstract class _$LocalNotifications extends BuildlessAsyncNotifier<void> {
  late final void Function(NotificationResponseBase)?
      onDidReceiveBackgroundNotificationResponse;
  late final void Function(NotificationResponseBase)?
      onDidReceiveNotificationResponse;

  FutureOr<void> build({
    void Function(NotificationResponseBase)?
        onDidReceiveBackgroundNotificationResponse,
    void Function(NotificationResponseBase)? onDidReceiveNotificationResponse,
  });
}

/// See also [LocalNotifications].
@ProviderFor(LocalNotifications)
const localNotificationsPod = LocalNotificationsFamily();

/// See also [LocalNotifications].
class LocalNotificationsFamily extends Family<AsyncValue<void>> {
  /// See also [LocalNotifications].
  const LocalNotificationsFamily();

  /// See also [LocalNotifications].
  LocalNotificationsProvider call({
    void Function(NotificationResponseBase)?
        onDidReceiveBackgroundNotificationResponse,
    void Function(NotificationResponseBase)? onDidReceiveNotificationResponse,
  }) {
    return LocalNotificationsProvider(
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  @override
  LocalNotificationsProvider getProviderOverride(
    covariant LocalNotificationsProvider provider,
  ) {
    return call(
      onDidReceiveBackgroundNotificationResponse:
          provider.onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse:
          provider.onDidReceiveNotificationResponse,
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
  String? get name => r'localNotificationsPod';
}

/// See also [LocalNotifications].
class LocalNotificationsProvider
    extends AsyncNotifierProviderImpl<LocalNotifications, void> {
  /// See also [LocalNotifications].
  LocalNotificationsProvider({
    void Function(NotificationResponseBase)?
        onDidReceiveBackgroundNotificationResponse,
    void Function(NotificationResponseBase)? onDidReceiveNotificationResponse,
  }) : this._internal(
          () => LocalNotifications()
            ..onDidReceiveBackgroundNotificationResponse =
                onDidReceiveBackgroundNotificationResponse
            ..onDidReceiveNotificationResponse =
                onDidReceiveNotificationResponse,
          from: localNotificationsPod,
          name: r'localNotificationsPod',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$localNotificationsHash,
          dependencies: LocalNotificationsFamily._dependencies,
          allTransitiveDependencies:
              LocalNotificationsFamily._allTransitiveDependencies,
          onDidReceiveBackgroundNotificationResponse:
              onDidReceiveBackgroundNotificationResponse,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        );

  LocalNotificationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.onDidReceiveBackgroundNotificationResponse,
    required this.onDidReceiveNotificationResponse,
  }) : super.internal();

  final void Function(NotificationResponseBase)?
      onDidReceiveBackgroundNotificationResponse;
  final void Function(NotificationResponseBase)?
      onDidReceiveNotificationResponse;

  @override
  FutureOr<void> runNotifierBuild(
    covariant LocalNotifications notifier,
  ) {
    return notifier.build(
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  @override
  Override overrideWith(LocalNotifications Function() create) {
    return ProviderOverride(
      origin: this,
      override: LocalNotificationsProvider._internal(
        () => create()
          ..onDidReceiveBackgroundNotificationResponse =
              onDidReceiveBackgroundNotificationResponse
          ..onDidReceiveNotificationResponse = onDidReceiveNotificationResponse,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<LocalNotifications, void> createElement() {
    return _LocalNotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocalNotificationsProvider &&
        other.onDidReceiveBackgroundNotificationResponse ==
            onDidReceiveBackgroundNotificationResponse &&
        other.onDidReceiveNotificationResponse ==
            onDidReceiveNotificationResponse;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(
        hash, onDidReceiveBackgroundNotificationResponse.hashCode);
    hash = _SystemHash.combine(hash, onDidReceiveNotificationResponse.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LocalNotificationsRef on AsyncNotifierProviderRef<void> {
  /// The parameter `onDidReceiveBackgroundNotificationResponse` of this provider.
  void Function(NotificationResponseBase)?
      get onDidReceiveBackgroundNotificationResponse;

  /// The parameter `onDidReceiveNotificationResponse` of this provider.
  void Function(NotificationResponseBase)? get onDidReceiveNotificationResponse;
}

class _LocalNotificationsProviderElement
    extends AsyncNotifierProviderElement<LocalNotifications, void>
    with LocalNotificationsRef {
  _LocalNotificationsProviderElement(super.provider);

  @override
  void Function(NotificationResponseBase)?
      get onDidReceiveBackgroundNotificationResponse =>
          (origin as LocalNotificationsProvider)
              .onDidReceiveBackgroundNotificationResponse;
  @override
  void Function(NotificationResponseBase)?
      get onDidReceiveNotificationResponse =>
          (origin as LocalNotificationsProvider)
              .onDidReceiveNotificationResponse;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
