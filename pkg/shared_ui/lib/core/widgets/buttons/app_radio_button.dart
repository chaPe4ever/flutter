// import 'package:flutter/material.dart' as material;
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AppRadioButton<T> extends StatelessWidget {
  const AppRadioButton({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    super.key,
  });

  final String? label;
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Transform.scale(
            scale: context.responsive(0.6, xs: 0.6),
            child: Transform.translate(
              offset: context.responsive(
                const Offset(-15, 0),
              ),
              child: Radio(
                fillColor: WidgetStateProperty.all(
                  context.colors.backgroundBrand,
                ),
                visualDensity: VisualDensity.compact,
                splashRadius: 0,
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
          ),
          if (label != null)
            Transform.translate(
              offset: context.responsive(
                const Offset(-15, 0),
              ),
              child: TextBody.s(label!),
            ),
        ],
      ),
    );
  }
}
