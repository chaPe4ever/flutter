import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    this.width,
    this.color,
    super.key,
  });

  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.deviderHeight,
      width: width ?? double.infinity,
      color: color ?? context.colors.contentTertiary,
    );
  }
}
