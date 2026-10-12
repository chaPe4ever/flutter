import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/assets_gen/assets.gen.dart';
import 'package:shared_ui/core/widgets/buttons/button_base.dart';

import '../../../shared/pump_shared_ui_widget.dart';

class _TestElevatedButton extends ElevatedButtonBase {
  const _TestElevatedButton({
    super.onTap,
    super.leading,
    super.trailing,
  }) : super(label: 'Elevated');

  @override
  Color? backgroundColor(BuildContext context) => Colors.blue;

  @override
  Color? childElementColor(BuildContext context) => Colors.white;

  @override
  Color? disabledColor(BuildContext context) => Colors.grey;

  @override
  Color? errorColor(BuildContext context) => Colors.red;

  @override
  Color? focusColor(BuildContext context) => Colors.green;

  @override
  Color? hoverColor(BuildContext context) => Colors.orange;

  @override
  Color? pressedColor(BuildContext context) => Colors.purple;

  @override
  Color? selectedColor(BuildContext context) => Colors.teal;

  @override
  EdgeInsets? padding(BuildContext context) => null;
}

class _TestOutlineButton extends OutlineButtonBase {
  const _TestOutlineButton({
    super.onTap,
    super.leading,
    super.trailing,
  }) : super(label: 'Outline');

  @override
  Color? backgroundColor(BuildContext context) => Colors.transparent;

  @override
  Color? childElementColor(BuildContext context) => Colors.black;

  @override
  Color? disabledColor(BuildContext context) => Colors.grey;

  @override
  Color? errorColor(BuildContext context) => Colors.red;

  @override
  Color? focusColor(BuildContext context) => Colors.green;

  @override
  Color? hoverColor(BuildContext context) => Colors.orange;

  @override
  Color? pressedColor(BuildContext context) => Colors.purple;

  @override
  Color? selectedColor(BuildContext context) => Colors.teal;
}

class _TestIconButton extends IconButtonBase {
  const _TestIconButton({super.onTap, super.icon, super.svg}) : super();

  @override
  Color? backgroundColor(BuildContext context) => Colors.blue;

  @override
  Color? childElementColor(BuildContext context) => Colors.white;

  @override
  Color? disabledColor(BuildContext context) => Colors.grey;

  @override
  Color? errorColor(BuildContext context) => Colors.red;

  @override
  Color? focusColor(BuildContext context) => Colors.green;

  @override
  Color? hoverColor(BuildContext context) => Colors.orange;

  @override
  Color? pressedColor(BuildContext context) => Colors.purple;

  @override
  Color? selectedColor(BuildContext context) => Colors.teal;

  @override
  EdgeInsets? padding(BuildContext context) => null;

  @override
  double? size(BuildContext context) => 24;
}

void _expectButtonStyleResolves(ButtonBase button, BuildContext context) {
  final style = button.buttonStyle(context);
  final shape = style.shape!;
  final overlay = style.overlayColor!;
  final background = style.backgroundColor!;
  final foreground = style.foregroundColor!;

  expect(shape.resolve({WidgetState.disabled}), isNotNull);
  expect(shape.resolve({WidgetState.focused}), isNotNull);
  expect(shape.resolve({WidgetState.hovered}), isNotNull);
  expect(shape.resolve({WidgetState.pressed}), isNotNull);
  expect(shape.resolve(<WidgetState>{}), isNotNull);

  for (final states in [
    {WidgetState.disabled},
    {WidgetState.hovered},
    {WidgetState.focused},
    {WidgetState.pressed},
    {WidgetState.error},
    {WidgetState.selected},
    <WidgetState>{},
  ]) {
    expect(overlay.resolve(states), isNotNull);
    expect(background.resolve(states), isNotNull);
  }

  expect(foreground.resolve({WidgetState.disabled}), isNotNull);
  expect(foreground.resolve({WidgetState.hovered}), isNotNull);
  expect(foreground.resolve(<WidgetState>{}), isNotNull);

  expect(style.textStyle!.resolve(<WidgetState>{}), isNotNull);
  expect(style.iconSize!.resolve(<WidgetState>{}), isNotNull);
}

void main() {
  testWidgets('ButtonBase resolves widget states and default borders', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      child: Builder(
        builder: (context) {
          const button = _TestElevatedButton();
          _expectButtonStyleResolves(button, context);
          button
            ..draggedColor(context)
            ..scrolledUnderColor(context)
            ..disabledChildElementColor(context)
            ..hoverChildElementColor(context)
            ..defaultBorder(context)
            ..focusedBorder(context)
            ..hoverBorder(context)
            ..disabledBorder(context);
          return const SizedBox();
        },
      ),
    );
  });

  testWidgets('ElevatedButtonBase and OutlineButtonBase build and debounce', (
    tester,
  ) async {
    var taps = 0;
    await pumpSharedUiWidget(
      tester,
      child: Column(
        children: [
          _TestElevatedButton(
            onTap: () => taps++,
            leading: (c) => Icon(Icons.star, color: c),
            trailing: (c) => Icon(Icons.arrow_forward, color: c),
          ),
          _TestElevatedButton(
            leading: (c) => Icon(Icons.star, color: c),
            trailing: (c) => Icon(Icons.arrow_forward, color: c),
          ),
          _TestOutlineButton(
            onTap: () => taps++,
            leading: (c) => Icon(Icons.star, color: c),
            trailing: (c) => Icon(Icons.arrow_forward, color: c),
          ),
          _TestOutlineButton(
            leading: (c) => Icon(Icons.star, color: c),
            trailing: (c) => Icon(Icons.arrow_forward, color: c),
          ),
          _TestIconButton(
            icon: Icons.favorite,
            onTap: () => taps++,
          ),
          const _TestIconButton(icon: Icons.favorite),
        ],
      ),
    );

    await tester.tap(find.text('Elevated').first);
    await tester.pump(const Duration(milliseconds: 400));
    expect(taps, greaterThan(0));
    expect(find.byType(OutlinedButton), findsNWidgets(2));
    expect(find.byType(IconButton), findsNWidgets(2));
  });

  testWidgets('IconButtonBase uses svg copyWith when svg provided', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              _TestIconButton(
                svg: Assets.svg.chat.svg(
                  width: 24,
                  height: 24,
                ),
                onTap: () {},
              ),
              _TestIconButton(
                svg: Assets.svg.chat.svg(
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          );
        },
      ),
    );
    expect(find.byType(SvgPicture), findsNWidgets(2));
  });
}
