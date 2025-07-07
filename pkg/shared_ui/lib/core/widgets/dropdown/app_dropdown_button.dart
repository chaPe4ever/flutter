import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AppDropdownButton extends DropdownButtonBase {
  const AppDropdownButton({
    required super.labelText,
    required super.items,
    super.onChanged,
    super.value,
    super.key,
    super.errorText,
    super.validator,
    super.helperText,
    super.focusNode,
  });

  @override
  State<AppDropdownButton> createState() => _AppDropdownButtonState();
}

class _AppDropdownButtonState extends State<AppDropdownButton> {
  late final Signal<String> errorTextSignal;
  @override
  void initState() {
    super.initState();
    errorTextSignal = Signal<String>('');
    errorTextSignal.value = widget.errorText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      focusNode: widget.focusNode,
      focusColor: Colors.transparent,
      autovalidateMode: AutovalidateMode.always,
      validator: (value) {
        final error = widget.validator?.call(value);
        errorTextSignal.value = error ?? widget.errorText ?? '';
        return error;
      },
      decoration: widget
          .decoration(context)
          ?.copyWith(
            labelStyle: context.textStyles.bodyS.copyWith(
              color: errorTextSignal.watch(context).isNotEmpty
                  ? context.colors.contentNegative
                  : widget.helperText != null
                  ? context.colors.contentSupport
                  : context.colors.contentPrimary,
            ),
          ),
      icon: Icon(
        errorTextSignal.watch(context).isNotEmpty
            ? Icons.error
            : Icons.arrow_drop_down,
        color: errorTextSignal.watch(context).isNotEmpty
            ? context.colors.contentNegative
            : context.colors.contentSecondary,
      ),
      value: widget.value,
      items: widget.items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: TextBody.s(item),
            ),
          )
          .toList(),
      onChanged: widget.onChanged,
    );
  }
}
