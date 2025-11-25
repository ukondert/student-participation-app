import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';
import '../../molecules/feedback/action_snack_bar.dart';
import '../../molecules/cards/participation_card.dart';

/// List organism displaying all participation entries for a single student.
/// Handles loading, empty, error and deletion of entries.
class StudentParticipationsList extends ConsumerWidget {
  final int studentId;
  final void Function()?
      onChanged; // callback after deletion to trigger refresh in parent if needed

  const StudentParticipationsList({
    super.key,
    required this.studentId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<ParticipationWithDetails>>(
      future: ref
          .read(participationRepositoryProvider)
          .getParticipationsWithDetailsForStudent(studentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return const Center(
              child: Text('Keine Protokolleinträge vorhanden.'));
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Dismissible(
              key: Key('participation_${item.participation.id}'),
              direction: DismissDirection.startToEnd,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: const Icon(Icons.delete, color: Colors.white, size: 32),
              ),
              onDismissed: (direction) async {
                await ref
                    .read(participationRepositoryProvider)
                    .deleteParticipation(item.participation.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Eintrag "${item.description}" gelöscht'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                onChanged?.call();
              },
              child: ParticipationCard(
                participation: item.participation,
                description: item.description,
                session: item.session,
              ),
            );
          },
        );
      },
    );
  }
}
