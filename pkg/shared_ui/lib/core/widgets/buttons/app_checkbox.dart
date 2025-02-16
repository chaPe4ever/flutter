// import 'package:flutter/material.dart' as material;
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    required this.value,
    required this.onChanged,
    this.label,
    super.key,
  });

  final String? label;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged?.call(value),
      child: Row(
        children: [
          Transform.scale(
            scale: context.responsive(0.6, xs: 0.6),
            child: Transform.translate(
              offset: context.responsive(
                const Offset(-15, 0),
              ),
              child: Checkbox(
                side: WidgetStateBorderSide.resolveWith(
                  (states) {
                    return states.contains(WidgetState.selected)
                        ? BorderSide(
                            color: context.colors.backgroundBrand,
                          )
                        : BorderSide(
                            color: context.colors.backgroundDisabled,
                          );
                  },
                ),
                visualDensity: VisualDensity.compact,
                splashRadius: 0,
                value: value,
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
