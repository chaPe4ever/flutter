import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ExpandableTextListWidget extends StatefulWidget {
  const ExpandableTextListWidget({
    required this.texts,
    this.textStyle,
    super.key,
  });

  final List<String> texts;
  final TextStyle? textStyle;

  @override
  State<ExpandableTextListWidget> createState() =>
      _ExpandableTextListWidgetState();
}

class _ExpandableTextListWidgetState extends State<ExpandableTextListWidget> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 260),
          reverseDuration: const Duration(milliseconds: 260),
          firstChild: _buildList(
            widget.texts.length > 3
                ? widget.texts.take(3).toList()
                : widget.texts,
          ),
          secondChild: _buildList(widget.texts),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
        if (widget.texts.length > 3)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 260),
            reverseDuration: const Duration(milliseconds: 260),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Row(
              children: [
                TextBody.m('\u2022'),
                const SizedBox(width: 2),
                AppButton.text(
                  onTap: () {
                    setState(() {
                      _expanded = true;
                    });
                  },
                  label: 'more'.tr(),
                ),
              ],
            ),
            secondChild: Row(
              children: [
                TextBody.m('\u2022'),
                const SizedBox(width: 2),
                AppButton.text(
                  onTap: () {
                    setState(() {
                      _expanded = false;
                    });
                  },
                  label: 'less'.tr(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildList(List<String> texts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: texts
          .map(
            (text) => Column(
              children: [
                TextBody.m(
                  text,
                ),
                const SizedBox(height: 2),
              ],
            ),
          )
          .toList(),
    );
  }
}
