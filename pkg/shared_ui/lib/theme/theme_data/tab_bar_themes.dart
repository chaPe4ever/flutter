// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class TabBarThemes {
  static TabBarTheme light() {
    return TabBarTheme(
      dividerHeight: 0.5,
      overlayColor: WidgetStateColor.transparent,
      splashFactory: NoSplash.splashFactory,
      dividerColor: AppSemanticColors.light.borderSelected,
      labelColor: AppSemanticColors.light.contentTabBarSelected,
      unselectedLabelColor: AppSemanticColors.light.contentSecondary,
      indicator: RoundedTabIndicator(
        color: AppSemanticColors.light.contentTabBarSelected,
        topLeft: AppRadius.circle,
        topRight: AppRadius.circle,
      ),
    );
  }

  static TabBarTheme dark() {
    return TabBarTheme(
      dividerHeight: 0.5,
      overlayColor: WidgetStateColor.transparent,
      splashFactory: NoSplash.splashFactory,
      dividerColor: AppSemanticColors.dark.borderSelected,
      labelColor: AppSemanticColors.dark.contentTabBarSelected,
      unselectedLabelColor: AppSemanticColors.dark.contentSecondary,
      indicator: RoundedTabIndicator(
        color: AppSemanticColors.dark.contentTabBarSelected,
        topLeft: AppRadius.circle,
        topRight: AppRadius.circle,
      ),
    );
  }
}

class RoundedTabIndicator extends Decoration {
  const RoundedTabIndicator({
    required this.color,
    this.indicatorHeight = 3,
    this.topLeft = Radius.zero,
    this.topRight = Radius.zero,
    this.bottomLeft = Radius.zero,
    this.bottomRight = Radius.zero,
  });

  final Color color;
  final double indicatorHeight;
  final Radius topLeft;
  final Radius topRight;
  final Radius bottomLeft;
  final Radius bottomRight;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return RoundedPainter(
      color: color,
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
      indicatorHeight: indicatorHeight,
    );
  }
}

class RoundedPainter extends BoxPainter {
  const RoundedPainter({
    required this.color,
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
    required this.indicatorHeight,
  });

  final Color color;
  final Radius topLeft;
  final Radius topRight;
  final Radius bottomLeft;
  final Radius bottomRight;
  final double indicatorHeight;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final startX = offset.dx;
    final endX = offset.dx + configuration.size!.width;
    final topY = offset.dy + configuration.size!.height - indicatorHeight;

    final rect = Rect.fromLTRB(startX, topY, endX, topY + indicatorHeight);
    final roundedRect = RRect.fromRectAndCorners(
      rect,
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );

    canvas.drawRRect(roundedRect, paint);
  }
}
