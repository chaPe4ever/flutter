import 'package:flutter/material.dart';
import 'package:shared_ui/core/widgets/loading/app_loading_indicator.dart';

// TODO: Customize it according to the app's design
/// Widget that displays a loading spinner while the app is starting up
class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: AppLoadingIndicator()),
    );
  }
}
