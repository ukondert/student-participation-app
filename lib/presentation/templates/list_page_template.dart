import 'package:flutter/material.dart';
import 'base_page_template.dart';
import '../organisms/navigation/custom_bottom_nav.dart';

/// List Page Template
/// 
/// Standard template for list-based pages with optional FAB and actions.
class ListPageTemplate extends StatelessWidget {
  final String title;
  final Widget list;
  final List<Widget>? actions;
  final VoidCallback? onAdd;
  final String? addButtonLabel;
  final IconData? addButtonIcon;
  final bool showBottomNavigation;
  final List<NavItem>? bottomNavItems;
  final int? currentNavIndex;
  final ValueChanged<int>? onNavTap;

  const ListPageTemplate({
    super.key,
    required this.title,
    required this.list,
    this.actions,
    this.onAdd,
    this.addButtonLabel,
    this.addButtonIcon,
    this.showBottomNavigation = false,
    this.bottomNavItems,
    this.currentNavIndex,
    this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return BasePageTemplate(
      title: title,
      body: list,
      actions: actions,
      floatingActionButton: onAdd != null
          ? FloatingActionButton(
              onPressed: onAdd,
              tooltip: addButtonLabel ?? 'Hinzufügen',
              child: Icon(addButtonIcon ?? Icons.add),
            )
          : null,
      showBottomNavigation: showBottomNavigation,
      bottomNavItems: bottomNavItems,
      currentNavIndex: currentNavIndex,
      onNavTap: onNavTap,
    );
  }
}
