import 'package:core/core.dart' hide ValueNotifierX;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_ui/shared_ui.dart';

enum TextFieldType { primary }

final FlutterSignal<bool> _isObscured = signal<bool>(true);

class AppTextField extends OutlineTextFieldBase {
  factory AppTextField({
    required String labelText,
    Key? key,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FocusNode? focusNode,
    FormFieldValidator<String>? validator,
    Widget? suffixIcon,
    VoidCallback? onClearButtonPressed,
    TextInputAction? textInputAction = TextInputAction.next,
    Iterable<String>? autofillHints,
    TextEditingController? controller,
    bool enabled = true,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return AppTextField._(
      onClearButtonPressed: onClearButtonPressed,
      suffixIcon: suffixIcon,
      key: key,
      onFieldSubmitted: onSubmitted,
      focusNode: focusNode,
      labelText: labelText,
      onChanged: onChanged,
      validator: validator,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      enabled: enabled,
      controller: controller,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      inputFormatters: inputFormatters,
    );
  }
  const AppTextField._({
    super.onClearButtonPressed,
    super.textInputAction,
    super.key,
    super.controller,
    super.labelText,
    super.enabled = true,
    super.obscureText,
    super.onChanged,
    super.validator,
    super.helperText,
    super.errorText,
    super.suffixIcon,
    super.prefixIcon,
    super.inputFormatters,
    super.keyboardType,
    super.focusNode,
    super.onFieldSubmitted,
    super.autofillHints,
    super.hintText,
    super.enableSuggestions = true,
    super.autocorrect = true,
  }) : type = TextFieldType.primary;

  factory AppTextField.email({
    required String labelText,
    Key? key,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FocusNode? focusNode,
    FormFieldValidator<String?>? validator,
    TextInputAction? textInputAction = TextInputAction.next,
  }) {
    return AppTextField._(
      key: key,
      onFieldSubmitted: onSubmitted,
      focusNode: focusNode,
      labelText: labelText,
      onChanged: onChanged,
      validator: (value) => validator?.call(value),
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      textInputAction: textInputAction,
    );
  }

  factory AppTextField.password({
    required String labelText,
    Key? key,
    String? hintText,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FocusNode? focusNode,
    FormFieldValidator<String?>? validator,
    TextInputAction? textInputAction = TextInputAction.next,
  }) {
    return AppTextField._(
      key: key,
      hintText: hintText,
      onFieldSubmitted: onSubmitted,
      focusNode: focusNode,
      labelText: labelText,
      onChanged: onChanged,
      validator: (value) => validator?.call(value),
      obscureText: _isObscured.watch,
      suffixIcon: AppIconButton.primary(
        icon: Icons.visibility,
        onTap: _isObscured.toggle,
      ),
      keyboardType: TextInputType.visiblePassword,
      autofillHints: const [AutofillHints.newPassword, AutofillHints.password],
      enableSuggestions: false,
      autocorrect: false,
      textInputAction: textInputAction,
    );
  }

  factory AppTextField.firstName({
    required String labelText,
    Key? key,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FocusNode? focusNode,
    FormFieldValidator<String?>? validator,
    TextInputAction? textInputAction = TextInputAction.next,
  }) {
    return AppTextField._(
      key: key,
      onFieldSubmitted: onSubmitted,
      focusNode: focusNode,
      labelText: labelText,
      onChanged: onChanged,
      validator: (value) => validator?.call(value),
      keyboardType: TextInputType.name,
      autofillHints: const [AutofillHints.givenName],
      textInputAction: textInputAction,
    );
  }

  factory AppTextField.lastName({
    required String labelText,
    Key? key,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FocusNode? focusNode,
    FormFieldValidator<String?>? validator,
    TextInputAction? textInputAction = TextInputAction.next,
  }) {
    return AppTextField._(
      key: key,
      onFieldSubmitted: onSubmitted,
      focusNode: focusNode,
      labelText: labelText,
      onChanged: onChanged,
      validator: (value) => validator?.call(value),
      keyboardType: TextInputType.name,
      autofillHints: const [AutofillHints.familyName],
      textInputAction: textInputAction,
    );
  }

  final TextFieldType type;
}
