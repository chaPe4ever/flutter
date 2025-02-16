import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AppLoadingIndicatorModal extends StatelessWidget {
  const AppLoadingIndicatorModal({
    super.key,
    this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: LayoutBuilder(
        builder: (context, contraints) {
          return Container(
            width: contraints.maxWidth,
            height: contraints.maxHeight,
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: context.responsive(120),
                height: context.responsive(140),
                decoration: BoxDecoration(
                  color: context.colors.backgroundModalLoading,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const AppLoadingIndicator(),
                    if (title != null)
                      Positioned(
                        bottom: context.responsive(AppSpacing.sectionXS),
                        child: TextBody.m(
                          title!,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
