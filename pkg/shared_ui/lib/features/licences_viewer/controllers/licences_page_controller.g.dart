// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'licences_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchLicences)
final fetchLicencesPod = FetchLicencesProvider._();

final class FetchLicencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LicenseEntry>>,
          List<LicenseEntry>,
          FutureOr<List<LicenseEntry>>
        >
    with
        $FutureModifier<List<LicenseEntry>>,
        $FutureProvider<List<LicenseEntry>> {
  FetchLicencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fetchLicencesPod',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fetchLicencesHash();

  @$internal
  @override
  $FutureProviderElement<List<LicenseEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LicenseEntry>> create(Ref ref) {
    return fetchLicences(ref);
  }
}

String _$fetchLicencesHash() => r'4a68470a19123ef5be199ced99b630629ac1634c';
