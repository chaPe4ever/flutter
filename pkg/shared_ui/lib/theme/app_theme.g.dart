// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(theme)
final themePod = ThemeProvider._();

final class ThemeProvider
    extends $FunctionalProvider<ThemeBase, ThemeBase, ThemeBase>
    with $Provider<ThemeBase> {
  ThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themePod',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeHash();

  @$internal
  @override
  $ProviderElement<ThemeBase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeBase create(Ref ref) {
    return theme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeBase>(value),
    );
  }
}

String _$themeHash() => r'5acefb10ef5243bd03eeafa6eccb3ff884f703d9';
