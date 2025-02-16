import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AppSearchbar extends StatefulWidget {
  const AppSearchbar({
    required this.onChanged,
    this.onClearTap,
    this.hintText,
    this.controller,
    super.key,
  });
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final VoidCallback? onClearTap;
  final TextEditingController? controller;

  @override
  State<AppSearchbar> createState() => _AppSearchbarState();
}

class _AppSearchbarState extends State<AppSearchbar> {
  late final Signal<String> text;
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    text = Signal('');
    controller.addListener(() {
      text.value = controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultSelectionStyle(
      cursorColor: context.colors.contentPrimary,
      child: SearchBar(
        controller: controller,
        textInputAction: TextInputAction.search,
        trailing: [
          AnimatedSwitcher(
            duration: Durations.long2,
            child: text.watch(context).isNotEmpty
                ? TouchableWidget(
                    child: Icon(
                      Icons.cancel_outlined,
                      color: context.colors.contentPrimary,
                    ),
                    onTap: () =>
                        Future.sync(() => widget.onClearTap?.call()).then((_) {
                      controller.clear();
                    }),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.contentS),
                    child: Icon(
                      Icons.search,
                      color: context.colors.contentDisabled,
                    ),
                  ),
          ),
        ],
        hintText: widget.hintText,
        onChanged: widget.onChanged,
        onSubmitted: (value) => FocusScope.of(context).unfocus(),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}
