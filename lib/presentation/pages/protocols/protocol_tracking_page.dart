import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';
import '../../templates/base_page_template.dart';
import '../settings/settings_page.dart';

class ProtocolTrackingPage extends ConsumerWidget {
  final int classId;
  final int subjectId;
  final String className;
  final String subjectName;
  final String subjectShortName;

  const ProtocolTrackingPage({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.className,
    required this.subjectName,
    required this.subjectShortName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsStream = ref.watch(classRepositoryProvider).watchStudents(classId);
    final behaviorsStream = ref.watch(participationRepositoryProvider).watchNegativeBehaviors();

    return BasePageTemplate(
      title: Platform.isWindows 
          ? '$className - $subjectName' 
          : '$className - $subjectShortName',
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
        ),
      ],
      body: StreamBuilder<List<Student>>(
        stream: studentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data!;

          if (students.isEmpty) {
            return const Center(
              child: Text('Keine Schüler in dieser Klasse.'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              
              // Watch participations for this student to get counts
              return StreamBuilder<List<Participation>>(
                stream: ref.watch(participationRepositoryProvider).watchParticipations(student.id, subjectId),
                builder: (context, participationSnapshot) {
                  int positiveCount = 0;
                  int negativeCount = 0;

                  if (participationSnapshot.hasData) {
                    final participations = participationSnapshot.data!;
                    positiveCount = participations.where((p) => p.isPositive).length;
                    negativeCount = participations.where((p) => !p.isPositive).length;
                  }

                  return GestureDetector(
                    onTap: () => _logPositive(context, ref, student),
                    onLongPress: () => _showNegativeMenu(context, ref, student, behaviorsStream),
                    child: Card(
                      child: Stack(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 40,
                              child: Text(
                                student.shortCode,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // Positive count (bottom left)
                          Positioned(
                            bottom: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$positiveCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Negative count (bottom right)
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$negativeCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
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

  void _logPositive(BuildContext context, WidgetRef ref, Student student) {
    ref.read(participationRepositoryProvider).addParticipation(
      student.id,
      subjectId,
      true,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ ${student.shortCode} +1'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showNegativeMenu(BuildContext context, WidgetRef ref, Student student, Stream<List<NegativeBehavior>> behaviorsStream) {
    showModalBottomSheet(
      context: context,
      builder: (context) => StreamBuilder<List<NegativeBehavior>>(
        stream: behaviorsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final behaviors = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: behaviors.length,
            itemBuilder: (context, index) {
              final behavior = behaviors[index];
              return ListTile(
                title: Text(behavior.description),
                onTap: () {
                  ref.read(participationRepositoryProvider).addParticipation(
                    student.id,
                    subjectId,
                    false,
                    behaviorId: behavior.id,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${student.shortCode}: ${behavior.description}'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.red,
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
