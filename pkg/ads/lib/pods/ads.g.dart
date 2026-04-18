// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Ads)
final adsPod = AdsProvider._();

final class AdsProvider extends $AsyncNotifierProvider<Ads, void> {
  AdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adsPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adsHash();

  @$internal
  @override
  Ads create() => Ads();
}

String _$adsHash() => r'aabcf9af1b6ef96d8d804352833c8db9e11e4216';

abstract class _$Ads extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
