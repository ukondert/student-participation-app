import 'package:flutter/material.dart';
import '../../../core/theme/tokens/colors.dart';
import '../../../core/theme/tokens/spacing.dart';

/// Avatar component for displaying user photos
/// 
/// Shows circular avatar with fallback to initials.
class Avatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final Color? backgroundColor;

  const Avatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = AppSpacing.avatarSizeMedium,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor ?? AppColors.primaryLight,
      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? AssetImage(imageUrl!)
          : null,
      child: imageUrl == null || imageUrl!.isEmpty
          ? Text(
              _getInitials(name),
              style: TextStyle(
                color: AppColors.textOnPrimary,
                fontSize: size / 2.5,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    
    final parts = trimmed.split(' ');
    if (parts.length == 1) {
      return parts[0].isNotEmpty 
          ? parts[0].substring(0, 1).toUpperCase()
          : '?';
    }
    return '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'.toUpperCase();
  }
}
