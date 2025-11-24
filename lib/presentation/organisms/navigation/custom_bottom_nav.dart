import 'package:flutter/material.dart';
import '../../../core/theme/tokens/colors.dart';
import '../../../core/theme/tokens/spacing.dart';
import '../../../core/theme/tokens/typography.dart';
import '../../../core/theme/tokens/elevation.dart';

/// Navigation item data model
class NavItem {
  final IconData icon;
  final String label;

  const NavItem({
    required this.icon,
    required this.label,
  });
}

/// Custom BottomNavigationBar component
/// 
/// Provides consistent bottom navigation styling across the application.
class CustomBottomNav extends StatelessWidget {
  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            ),
          )
          .toList(),
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: AppColors.surfacePrimary,
      selectedItemColor: AppColors.primaryBase,
      unselectedItemColor: AppColors.textSecondary,
      selectedLabelStyle: AppTypography.labelSmall.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTypography.labelSmall,
      selectedIconTheme: IconThemeData(
        size: AppSpacing.iconSizeMedium,
        color: AppColors.primaryBase,
      ),
      unselectedIconTheme: IconThemeData(
        size: AppSpacing.iconSizeMedium,
        color: AppColors.textSecondary,
      ),
      elevation: AppElevation.level3,
    );
  }
}
