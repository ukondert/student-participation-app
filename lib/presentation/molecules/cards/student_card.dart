import 'package:flutter/material.dart';
import '../../../core/theme/tokens/colors.dart';
import '../../../core/theme/tokens/spacing.dart';
import '../../../core/theme/tokens/typography.dart';
import '../../../core/theme/tokens/radius.dart';
import '../../../domain/entities/entities.dart';
import '../../atoms/indicators/avatar.dart';

/// Student card component
/// 
/// Displays student information in a card format with avatar,
/// name, and optional participation counters.
class StudentCard extends StatelessWidget {
  final Student student;
  final int? positiveCount;
  final int? negativeCount;
  final bool showCounters;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const StudentCard({
    super.key,
    required this.student,
    this.positiveCount,
    this.negativeCount,
    this.showCounters = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.xs,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: AppRadius.cardRadius,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Avatar
              Avatar(
                imageUrl: student.photoPath,
                name: '${student.firstName} ${student.lastName}',
                size: AppSpacing.avatarSizeMedium,
              ),
              SizedBox(width: AppSpacing.md),
              
              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${student.firstName} ${student.lastName}',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Kürzel: ${student.shortCode}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Participation Counters (optional)
              if (showCounters && (positiveCount != null || negativeCount != null)) ...[
                SizedBox(width: AppSpacing.sm),
                _buildCounters(),
              ],
              
              // Trailing Icon
              SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
                size: AppSpacing.iconSizeMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounters() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (positiveCount != null) ...[
          _buildCounter(
            count: positiveCount!,
            color: AppColors.participationPositive,
            icon: Icons.add_circle,
          ),
          SizedBox(width: AppSpacing.xs),
        ],
        if (negativeCount != null)
          _buildCounter(
            count: negativeCount!,
            color: AppColors.participationNegative,
            icon: Icons.remove_circle,
          ),
      ],
    );
  }

  Widget _buildCounter({
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.radiusSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: AppSpacing.xxs),
          Text(
            count.toString(),
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
