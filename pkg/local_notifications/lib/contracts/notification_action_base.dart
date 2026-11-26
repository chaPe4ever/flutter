import 'package:flutter/widgets.dart' show Color;

abstract class NotificationActionBase {
  const new({
    required this.id,
    required this.title,
    required this.titleColor,
  });
  final String id;
  final String title;
  final Color titleColor;
}
