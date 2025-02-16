import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

sealed class DropdownBase<T> extends StatefulWidget {
  const DropdownBase({
    required this.labelText,
    required this.items,
    this.onChanged,
    this.value,
    this.errorText,
    this.helperText,
    this.focusNode,
    this.validator,
    super.key,
  });

  final List<T> items;
  final ValueChanged<String?>? onChanged;
  final String? value;
  final String labelText;
  final String? errorText;
  final String? helperText;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
}

abstract class DropdownButtonBase extends DropdownBase<String> {
  const DropdownButtonBase({
    required super.labelText,
    required super.items,
    super.validator,
    super.onChanged,
    super.value,
    super.key,
    super.errorText,
    super.helperText,
    super.focusNode,
  });

  InputDecoration? decoration(BuildContext context) {
    return InputDecoration(
      errorText: errorText,
      helperText: helperText,
      labelText: labelText,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: helperText != null
              ? context.colors.borderSupport
              : AppSemanticColors.light.borderDisabled,
        ),
      ),
    );
  }
}

abstract class DropdownMenuBase extends DropdownBase<String> {
  const DropdownMenuBase({
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
}
