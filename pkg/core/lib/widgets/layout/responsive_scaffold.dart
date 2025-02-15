import 'package:core/widgets/layout/responsive_safe_area.dart';
import 'package:flutter/material.dart';

/// The basic page template used as a base widget for all pages in order to add
/// the app responsive layout and the app bar.
class ResponsiveScaffold extends StatelessWidget {
  /// Ctr
  const ResponsiveScaffold({
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    super.key,
  });

  final Widget child;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: ResponsiveSafeArea(child: child),
    );
  }
}
