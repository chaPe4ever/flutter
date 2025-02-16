import 'package:core/core.dart';
import 'package:flutter/material.dart';

class AppTabBar extends HookWidget implements PreferredSizeWidget {
  const AppTabBar({required this.tabs, this.controller, this.onTap, super.key});
  final List<String> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: tabs.length);

    return TabBar(
      isScrollable: tabs.length > 5,
      onTap: onTap ?? (controller ?? tabController).animateTo,
      controller: controller ?? tabController,
      tabs: tabs.map((text) => Tab(text: text)).toList(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
