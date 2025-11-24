import 'package:flutter/material.dart';
import '../../../core/theme/tokens/colors.dart';
import '../../../core/theme/tokens/spacing.dart';
import '../../../core/theme/tokens/typography.dart';
import '../../../core/theme/tokens/elevation.dart';

/// Custom AppBar component
/// 
/// Provides consistent app bar styling across the application.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTypography.headingMedium.copyWith(
          color: AppColors.textOnPrimary,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: AppColors.primaryBase,
      foregroundColor: AppColors.textOnPrimary,
      elevation: AppElevation.level2,
      leading: leading,
      actions: actions,
      bottom: bottom,
      iconTheme: IconThemeData(
        color: AppColors.textOnPrimary,
        size: AppSpacing.iconSizeMedium,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
