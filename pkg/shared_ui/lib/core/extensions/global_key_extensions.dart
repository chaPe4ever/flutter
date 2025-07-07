import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

extension GlobalKeyX on GlobalKey<ScaffoldMessengerState> {
  void showSnackBar({
    required String text,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionTap,
    Key? key,
  }) => currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        action: actionLabel == null || onActionTap == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                onPressed: onActionTap,
              ),
        content: TextBody.m(text),
        duration: duration,
        key: key,
      ),
    );
}
