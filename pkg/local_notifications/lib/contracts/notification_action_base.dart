import 'package:flutter/widgets.dart' show Color;

abstract class NotificationActionBase {
  const NotificationActionBase({
    required this.id,
    required this.title,
    required this.titleColor,
  });
  final String id;
  final String title;
  final Color titleColor;
}
