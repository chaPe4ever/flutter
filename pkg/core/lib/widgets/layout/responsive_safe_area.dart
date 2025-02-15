import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Template for ensuring content is within the safe area
class ResponsiveSafeArea extends StatelessWidget {
  /// Ctr
  const ResponsiveSafeArea({
    required this.child,
    this.hPadding = 20,
    super.key,
  });

  final Widget child;
  final double hPadding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: context.responsive(true),
      bottom: context.responsive(true),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.responsive(hPadding)),
        alignment: Alignment.topCenter,
        child: child,
      ),
    );
  }
}
