import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class TouchableWidget extends StatefulWidget {
  const TouchableWidget({
    required this.child,
    required this.onTap,
    this.showIsBusy = true,
    super.key,
  });

  final FutureOr<void> Function() onTap;
  final Widget child;
  final bool showIsBusy;

  @override
  State<TouchableWidget> createState() => _TouchableWidgetState();
}

class _TouchableWidgetState extends State<TouchableWidget> {
  final debounce = const Debounce();
  late final isBusy = signal(false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: createDebouncedCallback(
            () async {
              isBusy.value = true;
              await widget.onTap.call();
              isBusy.value = false;
            },
            debounce: debounce,
          ),
          child: widget.child,
        ),
        Visibility(
          visible: widget.showIsBusy && isBusy.watch(context),
          child: const AppLoadingIndicator(),
        ),
      ],
    );
  }
}
