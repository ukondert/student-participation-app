import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';
import '../../atoms/indicators/participation_badge.dart';

/// A card widget representing a student in the protocol tracking interface.
///
/// Displays the student's short code, participation counts, and handles
/// tap/long-press gestures for logging participations. The card color
/// changes based on the student's participation balance.
class StudentCard extends ConsumerWidget {
  final Student student;
  final int subjectId;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const StudentCard({
    super.key,
    required this.student,
    required this.subjectId,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Participation>>(
      stream: ref.watch(participationRepositoryProvider).watchParticipations(
        student.id,
        subjectId,
      ),
      builder: (context, participationSnapshot) {
        int positiveCount = 0;
        int negativeCount = 0;

        if (participationSnapshot.hasData) {
          final participations = participationSnapshot.data!;
          positiveCount = participations.where((p) => p.isPositive).length;
          negativeCount = participations.where((p) => !p.isPositive).length;
        }

        return GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Card(
            color: _getCardColor(positiveCount, negativeCount),
            child: Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      student.shortCode,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: ParticipationBadge(
                    count: positiveCount,
                    backgroundColor: Colors.green,
                    alignment: Alignment.bottomLeft,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: ParticipationBadge(
                    count: negativeCount,
                    backgroundColor: Colors.red,
                    alignment: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getCardColor(int positiveCount, int negativeCount) {
    final difference = positiveCount - negativeCount;

    if (difference >= 5) {
      return Colors.green.shade300;
    } else if (difference >= 3) {
      return Colors.green.shade200;
    } else if (difference >= 1) {
      return Colors.green.shade100;
    } else if (difference <= -3) {
      return Colors.red.shade300;
    } else if (difference <= -2) {
      return Colors.red.shade200;
    } else if (difference <= -1) {
      return Colors.red.shade100;
    } else {
      return Colors.grey.shade50;
    }
  }
}