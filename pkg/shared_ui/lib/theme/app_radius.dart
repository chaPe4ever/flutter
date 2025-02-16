import 'package:flutter/material.dart';

abstract class AppRadius {
  const AppRadius._();
  static const xxs = Radius.circular(2);
  static const xs = Radius.circular(4);
  static const s = Radius.circular(8);
  static const m = Radius.circular(12);
  static const l = Radius.circular(16);
  static const pill = Radius.circular(999);
  static const circle = Radius.circular(50);
}
