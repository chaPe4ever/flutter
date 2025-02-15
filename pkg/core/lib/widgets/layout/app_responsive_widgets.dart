import 'package:core/enums/breakpoint_enum.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
// ignore: implementation_imports

/// Responsive layout that shows two child widgets side by side if there is
/// enough space, or vertically stacked if there is not enough space.
class ResponsiveTwoColumnLayout extends StatelessWidget {
  /// Ctr
  const ResponsiveTwoColumnLayout({
    required this.startContent,
    required this.endContent,
    required this.spacing,
    this.startFlex = 1,
    this.endFlex = 1,
    this.breakpoint = BreakpointEnum.m,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.stretch,
    super.key,
  });

  final Widget startContent;
  final Widget endContent;
  final int startFlex;
  final int endFlex;
  final BreakpointEnum breakpoint;
  final double spacing;
  final MainAxisAlignment rowMainAxisAlignment;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final MainAxisAlignment columnMainAxisAlignment;
  final CrossAxisAlignment columnCrossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= breakpoint.end) {
          return Row(
            mainAxisAlignment: rowMainAxisAlignment,
            crossAxisAlignment: rowCrossAxisAlignment,
            children: [
              Flexible(flex: startFlex, child: startContent),
              SizedBox(width: spacing),
              Flexible(flex: endFlex, child: endContent),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: columnMainAxisAlignment,
            crossAxisAlignment: columnCrossAxisAlignment,
            children: [startContent, SizedBox(height: spacing), endContent],
          );
        }
      },
    );
  }
}

/// Scrollable widget that shows a responsive card with a given child widget.
/// Useful for displaying forms and other widgets that need to be scrollable.
class ResponsiveScrollableCard extends StatelessWidget {
  /// Ctr
  const ResponsiveScrollableCard({
    required this.child,
    this.padding = 20,
    super.key,
  });

  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveCenter(
        breakpoint: BreakpointEnum.m,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Card(
            child: Padding(padding: EdgeInsets.all(padding), child: child),
          ),
        ),
      ),
    );
  }
}

/// Reusable widget for showing a child with a maximum content width constraint.
/// If available width is larger than the maximum width, the child will be
/// centered.
/// If available width is smaller than the maximum width, the child use all the
/// available width.
class ResponsiveCenter extends StatelessWidget {
  /// Ctr
  const ResponsiveCenter({
    required this.child,
    super.key,
    this.breakpoint = BreakpointEnum.l,
    this.padding = EdgeInsets.zero,
  });

  final BreakpointEnum breakpoint;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Use Center as it has *unconstrained* width (loose constraints)
    return Center(
      // together with SizedBox to specify the max width (tight constraints)
      // See this thread for more info:
      // https://twitter.com/biz84/status/1445400059894542337
      child: SizedBox(
        width: breakpoint.end,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Sliver-equivalent of [ResponsiveCenter].
class ResponsiveSliverCenter extends StatelessWidget {
  /// Ctr
  const ResponsiveSliverCenter({
    required this.child,
    this.breakpoint = BreakpointEnum.l,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final BreakpointEnum breakpoint;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ResponsiveCenter(
        breakpoint: breakpoint,
        padding: padding,
        child: child,
      ),
    );
  }
}

class AppResponsiveScaledBox extends StatelessWidget {
  /// Ctr
  const AppResponsiveScaledBox({
    required this.child,
    this.width = 1920,
    super.key,
  });

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(width: width, child: child);
  }
}

/// A convenience wrapper for responsive [Row] and
/// [Column] switching with padding and spacing.
///
/// ResponsiveRowColumn combines responsiveness
/// behaviors for managing rows and columns into one
/// convenience widget. This widget requires all [children]
/// to be [ResponsiveRowColumnItem] widgets.
/// Row vs column layout is controlled by passing a
/// [AppRowColumnType] to [layout].
/// Add spacing between widgets with [rowSpacing] and
/// [columnSpacing]. Add padding around widgets with
/// [rowPadding] and [columnPadding].
///
/// See [ResponsiveRowColumnItem] for [Flex] and
/// [FlexFit] options.
class AppResponsiveRowColumn extends StatelessWidget {
  /// Ctr
  const AppResponsiveRowColumn({
    required this.layout,
    this.children = const [],
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowMainAxisSize = MainAxisSize.max,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.rowTextDirection,
    this.rowVerticalDirection = VerticalDirection.down,
    this.rowTextBaseline,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnMainAxisSize = MainAxisSize.max,
    this.columnCrossAxisAlignment = CrossAxisAlignment.center,
    this.columnTextDirection,
    this.columnVerticalDirection = VerticalDirection.down,
    this.columnTextBaseline,
    this.rowSpacing,
    this.columnSpacing,
    this.rowPadding = EdgeInsets.zero,
    this.columnPadding = EdgeInsets.zero,
    super.key,
  });

  final AppRowColumnType layout;
  final List<ResponsiveRowColumnItem> children;
  final MainAxisAlignment rowMainAxisAlignment;
  final MainAxisSize rowMainAxisSize;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final TextDirection? rowTextDirection;
  final VerticalDirection rowVerticalDirection;
  final TextBaseline? rowTextBaseline;
  final MainAxisAlignment columnMainAxisAlignment;
  final MainAxisSize columnMainAxisSize;
  final CrossAxisAlignment columnCrossAxisAlignment;
  final TextDirection? columnTextDirection;
  final VerticalDirection columnVerticalDirection;
  final TextBaseline? columnTextBaseline;
  final double? rowSpacing;
  final double? columnSpacing;
  final EdgeInsets rowPadding;
  final EdgeInsets columnPadding;

  @override
  Widget build(BuildContext context) {
    return ResponsiveRowColumn(
      layout: layout.toResponsiveRowColumnType,
      rowMainAxisAlignment: rowMainAxisAlignment,
      rowMainAxisSize: rowMainAxisSize,
      rowCrossAxisAlignment: rowCrossAxisAlignment,
      rowTextDirection: rowTextDirection,
      rowVerticalDirection: rowVerticalDirection,
      rowTextBaseline: rowTextBaseline,
      columnMainAxisAlignment: columnMainAxisAlignment,
      columnMainAxisSize: columnMainAxisSize,
      columnCrossAxisAlignment: columnCrossAxisAlignment,
      columnTextDirection: columnTextDirection,
      columnVerticalDirection: columnVerticalDirection,
      columnTextBaseline: columnTextBaseline,
      rowSpacing: rowSpacing,
      columnSpacing: columnSpacing,
      rowPadding: rowPadding,
      columnPadding: columnPadding,
      children: children,
    );
  }
}

/// Sets the max width of a widget.
class AppMaxWidthBox extends StatelessWidget {
  /// Ctr
  const AppMaxWidthBox({
    required this.maxWidth,
    required this.child,
    this.backgroundColor,
    this.alignment = Alignment.topCenter,
    super.key,
  });

  final double? maxWidth;

  /// Control the internal Stack alignment. This widget
  /// uses a Stack to set the widget to max width on top of
  /// a background.
  /// Defaults to [Alignment.topCenter] because app
  /// content is usually top aligned.
  final AlignmentGeometry alignment;
  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(
      maxWidth: maxWidth,
      backgroundColor: backgroundColor,
      alignment: alignment,
      child: child,
    );
  }
}

/// A GridView with responsive capabilities.
///
/// ResponsiveGridView extends [GridView] with
/// a custom [ResponsiveGridDelegate] [gridDelegate]
/// that adds more grid layout controls.
/// See [ResponsiveGridDelegate] for shrink and
/// fixed item size options.
/// Additional customization parameters [alignment]
/// and [maxRowCount] adds the ability to align
/// items and limit items in a row.
class AppResponsiveGrid extends StatelessWidget {
  /// Ctr
  const AppResponsiveGrid({
    required this.gridDelegate,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.alignment = Alignment.centerLeft,
    this.itemCount,
    this.maxRowCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    super.key,
  });

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  /// Align grid items together as a group.
  final AlignmentGeometry alignment;

  /// A custom [SliverGridDelegate] with item size control.
  final ResponsiveGridDelegate gridDelegate;
  final IndexedWidgetBuilder itemBuilder;
  final int? itemCount;
  final int? maxRowCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final Clip clipBehavior;
  final String? restorationId;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridView.builder(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      alignment: alignment,
      gridDelegate: gridDelegate,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      maxRowCount: maxRowCount,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      key: key,
    );
  }
}

/// Conditional values based on the active breakpoint.
///
/// Get a [value] that corresponds to active breakpoint
/// determined by [AppCondition]s set in [conditionalValues].
/// Set a [value] for when no condition is
/// active. Requires a parent [context] that contains
/// a [ResponsiveBreakpoints].
///
/// No validation is performed on [Condition]s so
/// valid conditions must be passed.
class AppResponsiveValue<T> extends ResponsiveValue<T> {
  /// Ctr
  AppResponsiveValue(
    super.context, {
    required List<AppCondition<T>> conditionalValues,
    super.defaultValue,
  }) : super(conditionalValues: conditionalValues);
}

/// A convenience wrapper for responsive [Visibility].
///
/// ResponsiveVisibility accepts [Condition]s in
/// [visibleConditions] and [hiddenConditions] convenience
/// fields. The [child] widget is [visible] by default.
class AppResponsiveVisibility extends StatelessWidget {
  /// Ctr
  const AppResponsiveVisibility({
    required this.child,
    this.visible = true,
    this.visibleConditions = const [],
    this.hiddenConditions = const [],
    this.replacement = const SizedBox.shrink(),
    this.maintainState = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.maintainInteractivity = false,
    super.key,
  });

  final Widget child;
  final bool visible;
  final List<AppCondition<bool>> visibleConditions;
  final List<AppCondition<bool>> hiddenConditions;
  final Widget replacement;
  final bool maintainState;
  final bool maintainAnimation;
  final bool maintainSize;
  final bool maintainSemantics;
  final bool maintainInteractivity;

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visible: visible,
      visibleConditions: visibleConditions,
      hiddenConditions: hiddenConditions,
      replacement: replacement,
      maintainState: maintainState,
      maintainAnimation: maintainAnimation,
      maintainSize: maintainSize,
      maintainSemantics: maintainSemantics,
      maintainInteractivity: maintainInteractivity,
      child: child,
    );
  }
}

class AppResponsiveConstraints extends StatelessWidget {
  /// Ctr
  const AppResponsiveConstraints({
    required this.child,
    this.constraint,
    this.conditionalConstraints = const [],
    super.key,
  });

  final Widget child;
  final BoxConstraints? constraint;
  final List<AppCondition<BoxConstraints?>> conditionalConstraints;

  @override
  Widget build(BuildContext context) {
    return ResponsiveConstraints(
      constraint: constraint,
      conditionalConstraints: conditionalConstraints,
      child: child,
    );
  }
}

///
enum AppRowColumnType { row, column }

///
extension AppRowColumnTypeX on AppRowColumnType {
  ResponsiveRowColumnType get toResponsiveRowColumnType => switch (this) {
    AppRowColumnType.row => ResponsiveRowColumnType.ROW,
    AppRowColumnType.column => ResponsiveRowColumnType.COLUMN,
  };
}

class AppBreakpoint extends Breakpoint {
  /// Ctr
  const AppBreakpoint({
    required super.start,
    required super.end,
    super.name,
    super.data,
  });
}

/// Internal equality comparators.
enum AppConditional { largerThan, equals, smallerThan, between }

/// Internal equality comparators extension.
extension AppConditionalX on AppConditional {
  Conditional get toConditional => switch (this) {
    AppConditional.largerThan => Conditional.LARGER_THAN,
    AppConditional.equals => Conditional.EQUALS,
    AppConditional.smallerThan => Conditional.SMALLER_THAN,
    AppConditional.between => Conditional.BETWEEN,
  };
}

/// A conditional value provider.
///
/// Provides the [value] when the [condition] is active.
/// Compare conditions by setting either [breakpoint] or
/// [name] values.
class AppCondition<T> extends Condition<T> {
  AppCondition.equals({required super.name, super.value, super.landscapeValue})
    : super.equals();

  const AppCondition.largerThan({
    super.breakpoint,
    super.name,
    super.value,
    super.landscapeValue,
  }) : super.largerThan();

  const AppCondition.smallerThan({
    super.breakpoint,
    super.name,
    super.value,
    super.landscapeValue,
  }) : super.smallerThan();

  /// Conditional when screen width is between [start] and [end] inclusive.
  const AppCondition.between({
    required super.start,
    required super.end,
    super.value,
    super.landscapeValue,
  }) : super.between();
}

class AppResponsiveBreakpoints extends ResponsiveBreakpoints {
  /// Ctr
  const AppResponsiveBreakpoints({
    required super.child,
    required super.breakpoints,
    super.breakpointsLandscape,
    super.landscapePlatforms,
    super.useShortestSide = false,
    super.debugLog = false,
    super.key,
  });

  static Widget builder({
    required Widget child,
    required List<Breakpoint> breakpoints,
    List<Breakpoint>? breakpointsLandscape,
    List<ResponsiveTargetPlatform>? landscapePlatforms,
    bool useShortestSide = false,
    bool debugLog = false,
  }) {
    return ResponsiveBreakpoints(
      breakpoints: breakpoints,
      breakpointsLandscape: breakpointsLandscape,
      landscapePlatforms: landscapePlatforms,
      useShortestSide: useShortestSide,
      debugLog: debugLog,
      child: child,
    );
  }

  static ResponsiveBreakpointsData of(BuildContext context) {
    final data =
        context
            .dependOnInheritedWidgetOfExactType<
              InheritedResponsiveBreakpoints
            >();
    if (data != null) return data.data;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'ResponsiveBreakpoints.of() called with a context that does not contain ResponsiveBreakpoints.',
      ),
      ErrorDescription(
        'No Responsive ancestor could be found starting from the context that was passed '
        'to ResponsiveBreakpoints.of(). Place a ResponsiveBreakpoints at the root of the app '
        'or supply a ResponsiveBreakpoints.builder.',
      ),
      context.describeElement('The context used was'),
    ]);
  }
}

/// A wrapper for [ResponsiveRowColumn] children with
/// responsiveness.
///
/// Control the order of widgets within [ResponsiveRowColumn]
/// by assigning a [rowOrder] or [columnOrder] value.
/// Widgets without an order value are ranked behind
/// those with order values.
/// Set a widget's [Flex] value through [rowFlex] and
/// [columnFlex]. Set a widget's [FlexFit] through
/// [rowFit] and [columnFit].
class AppResponsiveRowColumnItem extends ResponsiveRowColumnItem {
  /// Ctr
  const AppResponsiveRowColumnItem({
    required super.child,
    super.rowOrder = 1073741823,
    super.columnOrder = 1073741823,
    super.rowColumn = true,
    super.rowFlex,
    super.columnFlex,
    super.rowFit,
    super.columnFit,
    super.key,
  });
}
