import 'package:flutter/material.dart';

@immutable
class AppImgTheme extends ThemeExtension<AppImgTheme> {
  const AppImgTheme._({
    required this.color,
    this.size = 14.0,
  });

  factory AppImgTheme.light({
    Color defColor = Colors.black,
    double size = 14.0,
  }) {
    return AppImgTheme._(
      color: defColor,
      size: size,
    );
  }
  factory AppImgTheme.dark({
    Color defColor = Colors.white,
    double size = 14.0,
  }) {
    return AppImgTheme._(
      color: defColor,
      size: size,
    );
  }

  final Color color;
  final double size;

  @override
  AppImgTheme copyWith({
    Color? color,
    double? size,
  }) {
    return AppImgTheme._(
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }

  @override
  ThemeExtension<AppImgTheme> lerp(
    covariant ThemeExtension<AppImgTheme>? other,
    double t,
  ) {
    if (other is! AppImgTheme) {
      return this;
    }

    return AppImgTheme._(
      color: Color.lerp(color, other.color, t)!,
    );
  }
}
