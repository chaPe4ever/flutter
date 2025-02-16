import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

// TODO: Customize it according to the app's design
/// A widget to display when the app is starting up and an error occurs.
class AppStartupErrorWidget extends StatelessWidget {
  /// Ctr
  const AppStartupErrorWidget({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextBody.m(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.contentM),
            ElevatedButton(
              onPressed: onRetry,
              child: TextBody.m('retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
