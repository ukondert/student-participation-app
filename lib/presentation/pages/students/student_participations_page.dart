import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';
import '../../templates/base_page_template.dart';

class StudentParticipationsPage extends ConsumerStatefulWidget {
  final int studentId;
  final String studentName;
  final String studentShortCode;

  const StudentParticipationsPage({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.studentShortCode,
  });

  @override
  ConsumerState<StudentParticipationsPage> createState() => _StudentParticipationsPageState();
}

class _StudentParticipationsPageState extends ConsumerState<StudentParticipationsPage> {
  @override
  Widget build(BuildContext context) {
    return BasePageTemplate(
      title: Platform.isWindows 
          ? 'Protokolleinträge - ${widget.studentName}' 
          : 'Protokolleinträge - ${widget.studentShortCode}',
      body: FutureBuilder<List<Participation>>(
        future: ref.read(participationRepositoryProvider).getParticipationsForStudent(widget.studentId),
        builder: (context, participationSnapshot) {
          if (participationSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (participationSnapshot.hasError) {
            return Center(child: Text('Error: ${participationSnapshot.error}'));
          }

          final participations = participationSnapshot.data ?? [];

          if (participations.isEmpty) {
            return const Center(
              child: Text('Keine Protokolleinträge vorhanden.'),
            );
          }

          return FutureBuilder<List<NegativeBehavior>>(
            future: ref.read(participationRepositoryProvider).watchNegativeBehaviors().first,
            builder: (context, behaviorSnapshot) {
              final behaviors = behaviorSnapshot.data ?? [];
              final behaviorMap = {for (var b in behaviors) b.id: b};

              return ListView.builder(
                itemCount: participations.length,
                itemBuilder: (context, index) {
                  final participation = participations[index];
                  final dateStr = DateFormat('dd.MM.yyyy HH:mm').format(participation.date);
                  
                  String description;
                  Color backgroundColor;
                  
                  if (participation.isPositive) {
                    description = 'Positive Mitarbeit';
                    backgroundColor = Colors.green.shade50;
                  } else {
                    final behavior = behaviorMap[participation.behaviorId];
                    description = behavior?.description ?? participation.note ?? 'Negativ';
                    backgroundColor = Colors.red.shade50;
                  }

                  return Dismissible(
                    key: Key('participation_${participation.id}'),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    onDismissed: (direction) async {
                      await ref.read(participationRepositoryProvider).deleteParticipation(participation.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Eintrag "$description" gelöscht'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        setState(() {}); // Refresh the list
                      }
                    },
                    child: Card(
                      color: backgroundColor,
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: participation.isPositive ? Colors.green : Colors.red,
                          child: Icon(
                            participation.isPositive ? Icons.check : Icons.close,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          description,
                          style: TextStyle(
                            color: participation.isPositive ? Colors.green.shade900 : Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          dateStr,
                          style: TextStyle(
                            color: participation.isPositive ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
