import 'package:flutter/material.dart';
import '../../../core/theme/tokens/colors.dart';
import '../../../core/theme/tokens/spacing.dart';
import '../../../core/theme/tokens/typography.dart';
import '../../../core/theme/tokens/radius.dart';
import '../../atoms/buttons/primary_button.dart';
import '../../atoms/buttons/secondary_button.dart';

/// Confirm dialog organism component
/// 
/// Displays a confirmation dialog with customizable title, message, and actions.
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Bestätigen',
    this.cancelLabel = 'Abbrechen',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.cardRadius,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: AppTypography.headingMedium,
            ),
            SizedBox(height: AppSpacing.md),
            
            // Message
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SecondaryButton(
                  label: cancelLabel,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    onCancel?.call();
                  },
                ),
                SizedBox(width: AppSpacing.sm),
                PrimaryButton(
                  label: confirmLabel,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onConfirm?.call();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the confirm dialog and returns the result
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Bestätigen',
    String cancelLabel = 'Abbrechen',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
  }
}
