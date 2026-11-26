import 'package:core/widgets/layout/responsive_safe_area.dart';
import 'package:material_ui/material_ui.dart';

/// The basic page template used as a base widget for all pages in order to add
/// the app responsive layout and the app bar.
class ResponsiveScaffold extends StatelessWidget {
  /// Ctr
  const new({
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.horizontalPadding = 20,
    super.key,
  });

  final Widget child;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  /// Horizontal inset of the page body. Zero lets a header span the screen.
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: ResponsiveSafeArea(hPadding: horizontalPadding, child: child),
    );
  }
}
