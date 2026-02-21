// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_review_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the InAppReviewService

@ProviderFor(InAppReviewService)
final inAppReviewServicePod = InAppReviewServiceProvider._();

/// Provider for the InAppReviewService
final class InAppReviewServiceProvider
    extends $NotifierProvider<InAppReviewService, InAppReviewServiceBase> {
  /// Provider for the InAppReviewService
  InAppReviewServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inAppReviewServicePod',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inAppReviewServiceHash();

  @$internal
  @override
  InAppReviewService create() => InAppReviewService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InAppReviewServiceBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InAppReviewServiceBase>(value),
    );
  }
}

String _$inAppReviewServiceHash() =>
    r'af6919ec6108b9217abb58f61fa445832f499b1c';

/// Provider for the InAppReviewService

abstract class _$InAppReviewService extends $Notifier<InAppReviewServiceBase> {
  InAppReviewServiceBase build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<InAppReviewServiceBase, InAppReviewServiceBase>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InAppReviewServiceBase, InAppReviewServiceBase>,
              InAppReviewServiceBase,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
