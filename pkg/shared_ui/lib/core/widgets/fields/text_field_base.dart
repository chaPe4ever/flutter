import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_ui/shared_ui.dart';

abstract class TextFieldBase extends StatefulWidget {
  const TextFieldBase({super.key});

  TextStyle style(BuildContext context) => WidgetStateTextStyle.resolveWith(
    (states) {
      late final Color textColor;

      if (states.contains(WidgetState.error)) {
        textColor = context.colors.contentNegative;
      } else if (states.contains(WidgetState.focused)) {
        textColor = context.colors.borderFocused;
      } else if (states.contains(WidgetState.disabled)) {
        textColor = context.colors.contentDisabled;
      } else {
        textColor = context.colors.contentPrimary;
      }

      return context.textStyles.bodyS.copyWith(
        color: textColor,
      );
    },
  );
}

abstract class OutlineTextFieldBase<T extends Object> extends TextFieldBase {
  const OutlineTextFieldBase({
    super.key,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.controller,
    this.labelText,
    this.enabled = true,
    this.obscureText,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.validator,
    this.helperText,
    this.errorText,
    this.suffixIcon,
    this.suffixIconConstraints = const BoxConstraints(
      minHeight: AppSpacing.sectionS,
      minWidth: AppSpacing.sectionL,
    ),
    this.prefixIcon,
    this.prefixIconConstraints = const BoxConstraints(
      minHeight: AppSpacing.sectionS,
      minWidth: AppSpacing.sectionL,
    ),
    this.autofillHints,
    this.onEditingComplete,
    this.inputFormatters,
    this.keyboardType,
    this.maxLines = 1,
    this.focusNode,
    this.errorMaxLines = 1,
    this.textInputAction,
    this.onFieldSubmitted,
    this.hintText,
    this.onClearButtonPressed,
  });

  /// The controller for the text field.
  final TextEditingController? controller;

  /// The label text for the text field.
  final String? labelText;

  /// Whether the text field is enabled.
  final bool enabled;

  /// Whether the text field is obscured.
  final bool Function(BuildContext context)? obscureText;

  /// Called when the text field value changes.
  final ValueChanged<String>? onChanged;

  /// The autovalidate mode for the text field.
  final AutovalidateMode autovalidateMode;

  /// The validator for the text field.
  final FormFieldValidator<String?>? validator;

  /// The helper text for the text field.
  final String? helperText;

  /// The error text for the text field.
  final String? errorText;

  /// The suffix icon for the text field.
  final Widget? suffixIcon;

  /// The constraints for the suffix icon.
  final BoxConstraints? suffixIconConstraints;

  /// The prefix icon for the text field.
  final Widget? prefixIcon;

  /// The constraints for the prefix icon.
  final BoxConstraints? prefixIconConstraints;

  /// The autofillhints for app text field.
  final Iterable<String>? autofillHints;

  /// Called when the text field value completed.
  final VoidCallback? onEditingComplete;

  /// The input formatters for the text field.
  final List<TextInputFormatter>? inputFormatters;

  /// The keyboard type for the text field.
  final TextInputType? keyboardType;

  /// the maximum lines available in text field.
  final int maxLines;

  /// The focus node for the text field.
  final FocusNode? focusNode;

  /// The error max lines for the text field.
  final int? errorMaxLines;

  /// The text input action for the text field.
  final TextInputAction? textInputAction;

  /// The on submitted for the text field.
  final ValueChanged<String>? onFieldSubmitted;

  /// The hint text for the text field.
  final String? hintText;

  /// Called when the clear button is pressed.
  final VoidCallback? onClearButtonPressed;

  ///
  final bool enableSuggestions;

  ///
  final bool autocorrect;

  @override
  State<OutlineTextFieldBase> createState() => _OutlineTextFieldBaseState();
}

class _OutlineTextFieldBaseState extends State<OutlineTextFieldBase> {
  late final Signal<String> tfText;
  late final Signal<String> errorText;
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    tfText = signal('');
    errorText = signal('');
    errorText.value = widget.errorText ?? '';
    textController = widget.controller ?? TextEditingController(text: '');
    textController.addListener(() {
      tfText.value = textController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = context.responsive(
      context.textStyles.bodyS,
      mobile: context.textStyles.bodyS,
      tablet: context.textStyles.bodyM,
      desktop: context.textStyles.bodyL,
    );

    return TextFormField(
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      onEditingComplete: widget.onEditingComplete,
      autofillHints: widget.autofillHints,
      controller: textController,
      enabled: widget.enabled,
      obscureText: widget.obscureText?.call(context) ?? false,
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
      autovalidateMode: widget.autovalidateMode,
      validator: (value) {
        final error = widget.validator?.call(value);
        if (error != null) {
          errorText.value = error;
        }
        return error;
      },
      maxLines: widget.maxLines,
      style: textStyle.copyWith(color: widget.style(context).color),
      cursorColor: context.colors.borderFocused,
      cursorHeight: AppSpacing.contentXL,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        errorText: widget.errorText,
        labelStyle: context.textStyles.bodyS.copyWith(
          color: errorText.watch(context).isNotEmpty
              ? context.colors.contentNegative
              : widget.helperText != null
              ? context.colors.contentSupport
              : context.colors.contentPrimary,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.helperText != null
                ? context.colors.borderSupport
                : AppSemanticColors.light.borderDisabled,
          ),
        ),
        suffixIcon: SpacedRow(
          gapAtEnd: true,
          children: [
            Visibility(
              visible: tfText.watch(context).isNotEmpty,
              child: TouchableWidget(
                child: Icon(
                  Icons.cancel_outlined,
                  color: context.colors.contentPrimary,
                ),
                onTap: () =>
                    Future.sync(() => widget.onClearButtonPressed?.call()).then(
                      (_) {
                        tfText.value = '';
                        textController.clear();
                      },
                    ),
              ),
            ),
            Visibility(
              visible: errorText.watch(context).isNotEmpty,
              child: Icon(
                Icons.error,
                color: context.colors.contentNegative,
              ),
            ),
            widget.suffixIcon,
          ],
        ),
        suffixIconConstraints: widget.suffixIconConstraints,
        prefixIcon: widget.prefixIcon,
        prefixIconConstraints: widget.prefixIconConstraints,
      ).applyDefaults(context.themeData.inputDecorationTheme),
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
