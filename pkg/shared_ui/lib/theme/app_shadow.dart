import 'package:flutter/painting.dart';
import 'package:shared_ui/theme/app_effect_styles.dart';

abstract class AppShadow {
  const AppShadow._();
  static const List<BoxShadow> l1 = [
    AppEffectStyles.shadowL1Effect0,
    AppEffectStyles.shadowL1Effect1,
  ];

  static const List<BoxShadow> l2 = [
    AppEffectStyles.shadowL2Effect0,
    AppEffectStyles.shadowL2Effect1,
  ];

  static const List<BoxShadow> l3 = [
    AppEffectStyles.shadowL3Effect0,
    AppEffectStyles.shadowL3Effect1,
  ];

  static const List<BoxShadow> l4 = [
    AppEffectStyles.shadowL4Effect0,
    AppEffectStyles.shadowL4Effect1,
  ];

  static const List<BoxShadow> l5 = [
    AppEffectStyles.shadowL5Effect0,
    AppEffectStyles.shadowL5Effect1,
  ];

  static const List<BoxShadow> l6 = [
    AppEffectStyles.shadowL6Effect0,
    AppEffectStyles.shadowL6Effect1,
  ];
}
