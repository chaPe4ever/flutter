import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AppDropdownMenu extends DropdownMenuBase {
  const AppDropdownMenu({
    required super.labelText,
    required super.items,
    super.onChanged,
    super.value,
    super.key,
    super.errorText,
    super.helperText,
    super.focusNode,
    super.validator,
  });

  @override
  State<AppDropdownMenu> createState() => _AppDropdownMenuState();
}

class _AppDropdownMenuState extends State<AppDropdownMenu> {
  late final Signal<String> errorTextSignal;
  @override
  void initState() {
    super.initState();
    errorTextSignal = Signal<String>('');
    errorTextSignal.value = widget.errorText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      autovalidateMode: AutovalidateMode.always,
      validator: (value) {
        final error = widget.validator?.call(value);
        errorTextSignal.value = error ?? widget.errorText ?? '';
        return error;
      },
      builder: (FormFieldState<String> field) => DropdownMenu(
        initialSelection: widget.value,
        onSelected: widget.onChanged,
        focusNode: widget.focusNode,
        errorText: widget.errorText ?? field.errorText,
        helperText: widget.helperText,
        label: TextBody.s(
          widget.labelText,
          color: errorTextSignal.watch(context).isNotEmpty
              ? context.colors.contentNegative
              : widget.helperText != null
              ? context.colors.contentSupport
              : context.colors.contentPrimary,
        ),
        trailingIcon: Icon(
          errorTextSignal.watch(context).isNotEmpty
              ? Icons.error
              : Icons.arrow_drop_down,
          color: errorTextSignal.watch(context).isNotEmpty
              ? context.colors.contentNegative
              : context.colors.contentSecondary,
        ),
        dropdownMenuEntries: widget.items
            .map(
              (e) => DropdownMenuEntry<String>(
                style: ButtonStyle(
                  textStyle: WidgetStateProperty.all(
                    context.textStyles.bodyS,
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return context.colors.borderPrimary;
                    }
                    return context.colors.backgroundPrimary;
                  }),
                  foregroundColor: WidgetStateProperty.all(
                    context.colors.contentPrimary,
                  ),
                ),
                value: e,
                label: e,
              ),
            )
            .toList(),
      ),
    );
  }
}
