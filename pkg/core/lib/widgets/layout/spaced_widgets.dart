import 'package:core/core.dart';
import 'package:flutter/material.dart';

class SpacedColumn extends StatelessWidget {
  const SpacedColumn({
    required this.children,
    this.spacing = 4,
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.gapAtStart = false,
    this.gapAtEnd = false,
  });

  final List<Widget?> children;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool gapAtStart;
  final bool gapAtEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children:
          children
              .whereType<Widget>()
              .expand((x) => [Gap(spacing), x])
              .skip(gapAtStart ? 0 : 1)
              .toList()
            ..addAll([if (gapAtEnd) Gap(spacing)]),
    );
  }
}

class SpacedRow extends StatelessWidget {
  const SpacedRow({
    required this.children,
    this.spacing = 4,
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.gapAtStart = false,
    this.gapAtEnd = false,
  });

  final List<Widget?> children;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool gapAtStart;
  final bool gapAtEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children:
          children
              .whereType<Widget>()
              .expand((x) => [Gap(spacing), x])
              .skip(gapAtStart ? 0 : 1)
              .toList()
            ..addAll([if (gapAtEnd) Gap(spacing)]),
    );
  }
}
