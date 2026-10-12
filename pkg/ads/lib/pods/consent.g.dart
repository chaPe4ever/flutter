// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(consentClient)
final consentClientPod = ConsentClientProvider._();

final class ConsentClientProvider
    extends $FunctionalProvider<ConsentClient, ConsentClient, ConsentClient>
    with $Provider<ConsentClient> {
  ConsentClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consentClientPod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consentClientHash();

  @$internal
  @override
  $ProviderElement<ConsentClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ConsentClient create(Ref ref) {
    return consentClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConsentClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConsentClient>(value),
    );
  }
}

String _$consentClientHash() => r'55a91f3761e8d4856ce81e9e81a9b16ac9718a70';
