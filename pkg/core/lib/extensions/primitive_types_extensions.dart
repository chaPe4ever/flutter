import 'package:core/core.dart';
import 'package:core/value_objects/unique_id.dart';
import 'package:flutter/widgets.dart';

/// List extension
extension ListX<T> on List<T> {
  /// Sort any given list and return it. Normally the dart sort method sorts
  /// a list but doesn't return it, because sort returns void
  List<T> sorted(int Function(T a, T b) compare) =>
      List.from(this)..sort(compare);
}

/// String extensions
extension StringX on String {
  /// Appends to the current string an [appendix]
  String append(String appendix) => '$this$appendix';
  String prepend(String prefix, {bool slashSeperated = true}) =>
      '$prefix${slashSeperated ? '/' : ''}$this';
  String suffix(String appendix, {bool slashSeperated = true}) =>
      '$this${slashSeperated ? '/' : ''}$appendix'.replaceAll('//', '/');
  String toSnakeCase({bool asLowerCase = true}) {
    final rawSnakeCase = replaceAllMapped(
      RegExp('(?<!^)([A-Z])'),
      (match) => '_${match.group(1)}',
    );
    if (asLowerCase) {
      return rawSnakeCase.toLowerCase();
    } else {
      return rawSnakeCase;
    }
  }

  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  UniqueId toUniqueId() => UniqueId.fromUniqueString(this);

  String get hardcoded => this;
}

/// Int extensions
extension IntX on int {
  /// Check if the status code is between 200-299
  bool get isOk => this >= 200 && this < 300;

  /// Appends to the current int an [appendix] and return it as a string
  String append(String appendix) => '$this$appendix';

  int get hardcoded => this;
}

extension NumExtensions on num {
  num get hardcoded => this;
}

extension DoubleExtensions on double {
  double get hardcoded => this;
}

extension BoolExtensions on bool {
  bool get hardcoded => this;
}

extension ObjectX on Object {
  CoreException toCoreException({CoreException? customEx}) =>
      this is CoreException
      ? this as CoreException
      : customEx ??
            UnknownCoreException(innerError: this, st: StackTrace.current);
}

extension ValueNotifierX on ValueNotifier<bool> {
  void toggle() {
    value = !value;
  }
}
