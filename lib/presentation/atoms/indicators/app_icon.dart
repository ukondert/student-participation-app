import 'package:flutter/material.dart';
import '../../../core/theme/tokens/colors.dart';
import '../../../core/theme/tokens/spacing.dart';

/// App-specific icon wrapper
/// 
/// Provides consistent icon sizing and coloring.
class AppIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const AppIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
  });

  const AppIcon.small({
    super.key,
    required this.icon,
    this.color,
  }) : size = AppSpacing.iconSizeSmall;

  const AppIcon.medium({
    super.key,
    required this.icon,
    this.color,
  }) : size = AppSpacing.iconSizeMedium;

  const AppIcon.large({
    super.key,
    required this.icon,
    this.color,
  }) : size = AppSpacing.iconSizeLarge;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size ?? AppSpacing.iconSizeMedium,
      color: color ?? AppColors.textPrimary,
    );
  }
}
