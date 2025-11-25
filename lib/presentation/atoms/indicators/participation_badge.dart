import 'package:flutter/material.dart';

/// A badge widget that displays a participation count with a colored background.
///
/// Used in the StudentCard to show positive (green) and negative (red) participation counts.
class ParticipationBadge extends StatelessWidget {
  final int count;
  final Color backgroundColor;
  final Alignment alignment;

  const ParticipationBadge({
    super.key,
    required this.count,
    required this.backgroundColor,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
