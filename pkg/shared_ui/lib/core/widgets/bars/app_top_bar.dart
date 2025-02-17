// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/core/assets_gen/assets.gen.dart';
import 'package:shared_ui/shared_ui.dart';

/// The default app bar for the app
class AppTopBar extends ConsumerWidget implements PreferredSizeWidget {
  /// Ctr
  const AppTopBar({
    required this.title,
    this.actions,
    this.bottom,
    this.leading,
    this.customRreferredSize = const Size.fromHeight(kToolbarHeight),
    this.isParentPage,
    this.shape,
    super.key,
  });

  final List<ActionBase>? actions;
  final PreferredSizeWidget? bottom;
  final Size customRreferredSize;
  final Widget? leading;
  final ShapeBorder? shape;
  final String title;
  final bool? isParentPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isParentPage = context
            .goRouter.routeInformationProvider.value.uri.pathSegments.length <=
        1;

    final leadingFallback = this.isParentPage ?? isParentPage
        ? null
        : AppIconButton.back(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
          );
    return AppBar(
      leading: leading ?? leadingFallback,
      title: Padding(
        padding: isParentPage ? AppPadding.mobilePage : EdgeInsets.zero,
        child: TextTitle.l(title),
      ),
      centerTitle: false,
      bottom: bottom,
      shape: shape,
      actions: [
        SpacedRow(
          spacing: AppSpacing.sectionXS,
          gapAtEnd: true,
          children: actions?.toList() ?? [],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => customRreferredSize;
}

List<ActionBase> appTopBarActions({
  ActionModel? userActionModel,
  ActionModel? chatActionModel,
}) {
  return <ActionBase>[
    if (chatActionModel != null) ChatAction(model: chatActionModel),
    if (userActionModel != null) UserAction(model: userActionModel),
  ];
}

class UserAction extends ActionBase {
  const UserAction({super.model, super.key});

  @override
  Widget build(BuildContext context) {
    return TouchableWidget(
      onTap: model?.onTap ?? () {},
      child: model?.icon ??
          Assets.svg.person.svgFromUIPkg(
            context,
            color:
                model?.onTap == null ? context.colors.backgroundDisabled : null,
          ),
    );
  }
}

final class ChatAction extends ActionBase {
  const ChatAction({super.model, super.key});
  @override
  Widget build(BuildContext context) {
    return TouchableWidget(
      onTap: model?.onTap ?? () {},
      child: model?.icon ??
          Assets.svg.chat.svgFromUIPkg(
            context,
            color:
                model?.onTap == null ? context.colors.backgroundDisabled : null,
          ),
    );
  }
}

abstract class ActionBase extends StatelessWidget {
  const ActionBase({
    this.model,
    super.key,
  });

  final ActionModel? model;
}

class ActionModel extends Equatable {
  const ActionModel({
    required this.onTap,
    this.icon,
  });

  final Widget? icon;
  final VoidCallback onTap;

  @override
  List<Object?> get props => [icon, onTap];
}
