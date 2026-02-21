// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_notification_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalNotifications)
final localNotificationsPod = LocalNotificationsProvider._();

final class LocalNotificationsProvider
    extends $NotifierProvider<LocalNotifications, LocalNotificationsBase> {
  LocalNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localNotificationsPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localNotificationsHash();

  @$internal
  @override
  LocalNotifications create() => LocalNotifications();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalNotificationsBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalNotificationsBase>(value),
    );
  }
}

String _$localNotificationsHash() =>
    r'02ebec78777a1d1eb7a4cfbde306282c0dbfd15b';

abstract class _$LocalNotifications extends $Notifier<LocalNotificationsBase> {
  LocalNotificationsBase build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<LocalNotificationsBase, LocalNotificationsBase>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LocalNotificationsBase, LocalNotificationsBase>,
              LocalNotificationsBase,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
