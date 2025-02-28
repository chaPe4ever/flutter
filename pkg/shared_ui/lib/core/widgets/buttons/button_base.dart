import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

typedef IconBuilder = Widget Function(Color? iconColor);

abstract class ButtonBase extends StatelessWidget {
  const ButtonBase({super.key});

  /// The state when the user navigates with the keyboard to a given widget.
  ///
  /// This can also sometimes be triggered when a widget is tapped. For example,
  /// when a [TextField] is tapped, it becomes focused.
  Color? focusColor(BuildContext context);

  /// The state when the user drags their mouse cursor over the given widget.
  Color? hoverColor(BuildContext context);

  /// The state when the user is actively pressing down on the given widget.
  Color? pressedColor(BuildContext context);

  /// The state when this widget is being dragged from one place to another by
  /// the user.
  Color draggedColor(BuildContext context) => Colors.transparent;

  /// The state when this item has been selected.
  ///
  /// This applies to things that can be toggled (such as chips and checkboxes)
  /// and things that are selected from a set of options (such as tabs and radio
  ///  buttons).
  Color? selectedColor(BuildContext context);

  /// The state when this widget overlaps the content of a scrollable below.
  ///
  /// Used by [AppBar] to indicate that the primary scrollable's
  /// content has scrolled up and behind the app bar.
  Color scrolledUnderColor(BuildContext context) => Colors.transparent;

  /// The state when this widget is disabled and cannot be interacted with.
  ///
  /// Disabled widgets should not respond to hover, focus, press, or drag
  /// interactions.
  Color? disabledColor(BuildContext context);

  /// The state when the widget has entered some form of invalid state.
  Color? errorColor(BuildContext context);

  /// The background color of button.
  Color? backgroundColor(BuildContext context);

  /// The inner child color of button
  Color? childElementColor(BuildContext context);

  /// The disabled inner child color of button
  Color? disabledChildElementColor(BuildContext context) =>
      context.colors.contentDisabled;

  /// The focus inner child color of button
  Color? hoverChildElementColor(BuildContext context) =>
      childElementColor(context);

  /// The default border for the button.
  BorderSide defaultBorder(BuildContext context) => BorderSide.none;

  /// The focused border for the button.
  BorderSide focusedBorder(BuildContext context) => BorderSide.none;

  /// The hover border for the button.
  BorderSide hoverBorder(BuildContext context) => BorderSide.none;

  /// The disabled border for the button.
  BorderSide disabledBorder(BuildContext context) => BorderSide.none;

  ButtonStyle buttonStyle(BuildContext context) => ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        splashFactory: NoSplash.splashFactory,
        shape: WidgetStateProperty.resolveWith(
          (states) {
            const shape = RoundedRectangleBorder(
              borderRadius: BorderRadius.all(AppRadius.pill),
            );

            if (states.contains(WidgetState.disabled)) {
              return shape.copyWith(side: disabledBorder(context));
            }

            if (states.contains(WidgetState.focused)) {
              return shape.copyWith(side: focusedBorder(context));
            }

            if (states.contains(WidgetState.hovered)) {
              return shape.copyWith(side: hoverBorder(context));
            }

            if (states.contains(WidgetState.pressed)) {
              return shape.copyWith(side: focusedBorder(context));
            }

            return shape.copyWith(side: defaultBorder(context));
          },
        ),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledColor(context);
            }

            if (states.contains(WidgetState.hovered)) {
              return hoverColor(context);
            }

            if (states.contains(WidgetState.focused)) {
              return focusColor(context);
            }

            if (states.contains(WidgetState.pressed)) {
              return pressedColor(context);
            }

            if (states.contains(WidgetState.error)) {
              return errorColor(context);
            }

            if (states.contains(WidgetState.selected)) {
              return selectedColor(context);
            }

            return backgroundColor(context);
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledColor(context);
            }

            if (states.contains(WidgetState.hovered)) {
              return hoverColor(context);
            }

            if (states.contains(WidgetState.focused)) {
              return focusColor(context);
            }

            if (states.contains(WidgetState.pressed)) {
              return pressedColor(context);
            }

            if (states.contains(WidgetState.error)) {
              return errorColor(context);
            }

            if (states.contains(WidgetState.selected)) {
              return selectedColor(context);
            }

            return backgroundColor(context);
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledChildElementColor(context);
            }
            if (states.contains(WidgetState.hovered)) {
              return hoverChildElementColor(context);
            }

            return childElementColor(context);
          },
        ),
        textStyle: WidgetStateProperty.resolveWith(
          (states) {
            return context.responsive(
              context.textStyles.labelM,
              mobile: context.textStyles.labelL,
              tablet: context.textStyles.labelL,
              desktop: context.textStyles.labelL,
            );
          },
        ),
        iconSize: WidgetStateProperty.resolveWith(
          (states) {
            return context.responsive(
              AppSpacing.contentXL,
              s: AppSpacing.contentXL,
              m: AppSpacing.contentXL,
              l: AppSpacing.sectionS,
              xl: AppSpacing.sectionS,
            );
          },
        ),
      );
}

abstract class ElevatedButtonBase extends ButtonBase {
  const ElevatedButtonBase({
    required this.label,
    super.key,
    this.onTap,
    this.leading,
    this.trailing,
    this.fixedSize,
  });

  /// The label for the text button.
  final String label;

  /// The callback function for the text button.
  final VoidCallback? onTap;

  /// The leading icon for the text button.
  final IconBuilder? leading;

  /// The trailing icon for the text button.
  final IconBuilder? trailing;

  /// The fixed size for the text button.
  final Size? fixedSize;

  /// EdgeInsets for the button.
  EdgeInsets? padding(BuildContext context);

  static const _debounce = Debounce();

  @override
  Widget build(BuildContext context) {
    final inBetweenSpace = context.responsive(
      AppSpacing.contentS,
      s: AppSpacing.contentM,
      m: AppSpacing.contentL,
      l: AppSpacing.contentXL,
      xl: AppSpacing.sectionS,
    );

    final btStyle = buttonStyle(context);

    final padding = this.padding(context);

    return ElevatedButton(
      style: btStyle.copyWith(
        padding: WidgetStateProperty.all(padding),
        fixedSize: WidgetStateProperty.all(fixedSize),
        tapTargetSize: padding == null
            ? MaterialTapTargetSize.shrinkWrap
            : MaterialTapTargetSize.padded,
      ),
      onPressed: createDebouncedCallback(onTap, debounce: _debounce),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!(
              onTap != null
                  ? childElementColor(context)
                  : disabledChildElementColor(context),
            ),
            SizedBox(width: inBetweenSpace),
          ],
          Text(
            label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (trailing != null) ...[
            SizedBox(width: inBetweenSpace),
            trailing!(
              onTap != null
                  ? childElementColor(context)
                  : disabledChildElementColor(context),
            ),
          ],
        ],
      ),
    );
  }
}

abstract class OutlineButtonBase extends ButtonBase {
  const OutlineButtonBase({
    required this.label,
    super.key,
    this.onTap,
    this.leading,
    this.trailing,
    this.fixedSize,
  });

  /// The label for the text button.
  final String label;

  /// The callback function for the text button.
  final VoidCallback? onTap;

  /// The leading icon for the text button.
  final IconBuilder? leading;

  /// The trailing icon for the text button.
  final IconBuilder? trailing;

  /// The fixed size for the text button.
  final Size? fixedSize;

  /// EdgeInsets for the button.
  EdgeInsets? padding(BuildContext context) => null;

  static const _debounce = Debounce();

  @override
  Widget build(BuildContext context) {
    final inBetweenSpace = context.responsive(
      AppSpacing.contentS,
      xs: AppSpacing.contentS,
      s: AppSpacing.contentM,
      m: AppSpacing.contentL,
      l: AppSpacing.contentXL,
      xl: AppSpacing.sectionS,
    );

    final btStyle = buttonStyle(context);

    final padding = this.padding(context);

    return OutlinedButton(
      style: btStyle.copyWith(
        padding: WidgetStateProperty.all(padding),
        fixedSize: WidgetStateProperty.all(fixedSize),
        tapTargetSize: padding == null
            ? MaterialTapTargetSize.shrinkWrap
            : MaterialTapTargetSize.padded,
      ),
      onPressed: createDebouncedCallback(onTap, debounce: _debounce),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!(
              onTap != null
                  ? childElementColor(context)
                  : disabledChildElementColor(context),
            ),
            SizedBox(width: inBetweenSpace),
          ],
          Text(
            label,
            textAlign: TextAlign.center,
          ),
          if (trailing != null) ...[
            SizedBox(width: inBetweenSpace),
            trailing!(
              onTap != null
                  ? childElementColor(context)
                  : disabledChildElementColor(context),
            ),
          ],
        ],
      ),
    );
  }
}

abstract class IconButtonBase extends ButtonBase {
  const IconButtonBase({
    this.svg,
    this.icon,
    super.key,
    this.onTap,
    this.fixedSize,
  }) : assert(
          svg != null || icon != null,
          'Either svg or icon must be provided',
        );

  /// The svg for the icon button.
  final SvgPicture? svg;

  final IconData? icon;

  /// The callback function for the text button.
  final VoidCallback? onTap;

  /// The fixed size for the icon button.
  final Size? fixedSize;

  /// EdgeInsets for the button.
  EdgeInsets? padding(BuildContext context);

  /// Size for the icon button.
  double? size(BuildContext context);

  static const _debounce = Debounce();

  @override
  Widget build(BuildContext context) {
    final padding = this.padding(context);

    final size = this.size(context);

    return IconButton(
      style: buttonStyle(context).copyWith(
        padding: WidgetStateProperty.all(padding),
        fixedSize: WidgetStateProperty.all(fixedSize),
        tapTargetSize: padding == null
            ? MaterialTapTargetSize.shrinkWrap
            : MaterialTapTargetSize.padded,
      ),
      onPressed: createDebouncedCallback(onTap, debounce: _debounce),
      icon: svg?.copyWith(
            color: onTap != null
                ? childElementColor(context)
                : disabledChildElementColor(context),
          ) ??
          Icon(
            icon,
            size: size,
          ),
    );
  }
}
