import 'package:flutter/material.dart';
import '../organisms/navigation/custom_app_bar.dart';
import '../organisms/navigation/custom_bottom_nav.dart';

/// Base Page Template
/// 
/// Provides standard page structure with AppBar, Body, and optional BottomNav.
/// This is the foundation template that all other templates build upon.
class BasePageTemplate extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final bool showBottomNavigation;
  final List<NavItem>? bottomNavItems;
  final int? currentNavIndex;
  final ValueChanged<int>? onNavTap;
  final bool centerTitle;

  const BasePageTemplate({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.showBottomNavigation = false,
    this.bottomNavItems,
    this.currentNavIndex,
    this.onNavTap,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        actions: actions,
        leading: leading,
        centerTitle: centerTitle,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNavigation && bottomNavItems != null
          ? CustomBottomNav(
              items: bottomNavItems!,
              currentIndex: currentNavIndex ?? 0,
              onTap: onNavTap ?? (_) {},
            )
          : null,
    );
  }
}
