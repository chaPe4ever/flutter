// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_review.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for InAppReview instance

@ProviderFor(inAppReview)
final inAppReviewPod = InAppReviewProvider._();

/// Provider for InAppReview instance

final class InAppReviewProvider
    extends $FunctionalProvider<InAppReview, InAppReview, InAppReview>
    with $Provider<InAppReview> {
  /// Provider for InAppReview instance
  InAppReviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inAppReviewPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inAppReviewHash();

  @$internal
  @override
  $ProviderElement<InAppReview> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  InAppReview create(Ref ref) {
    return inAppReview(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InAppReview value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InAppReview>(value),
    );
  }
}

String _$inAppReviewHash() => r'55f9d081d3567d1f94e18bd68dd81deb208c8bb4';
