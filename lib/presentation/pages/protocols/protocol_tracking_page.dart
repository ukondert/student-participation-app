import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';
import '../../templates/base_page_template.dart';
import '../../molecules/cards/student_participation_card.dart';
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
    final activeSessionStream = ref.watch(participationRepositoryProvider).watchActiveSession(subjectId);

    return StreamBuilder<ProtocolSession?>(
      stream: activeSessionStream,
      builder: (context, sessionSnapshot) {
        final activeSession = sessionSnapshot.data;

        return BasePageTemplate(
          title: Platform.isWindows 
              ? '$className - $subjectName' 
              : '$className - $subjectShortName',
          actions: [
            if (activeSession != null)
              IconButton(
                icon: const Icon(Icons.stop_circle),
                tooltip: 'Stunde beenden',
                onPressed: () => _endSession(context, ref, activeSession.id),
              )
            else
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
          body: _buildStudentGrid(context, ref, studentsStream, behaviorsStream, activeSession),
        );
      },
    );
  }

  Widget _buildStudentGrid(
    BuildContext context,
    WidgetRef ref,
    Stream<List<Student>> studentsStream,
    Stream<List<NegativeBehavior>> behaviorsStream,
    ProtocolSession? activeSession,
  ) {
    return StreamBuilder<List<Student>>(
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
            return StudentCard(
              student: student,
              subjectId: subjectId,
              onTap: () => _logPositive(context, ref, student, activeSession),
              onLongPress: () => _showNegativeMenu(context, ref, student, behaviorsStream, activeSession),
            );
          },
        );
      },
    );
  }

  void _logPositive(BuildContext context, WidgetRef ref, Student student, ProtocolSession? activeSession) {
    print('Logging positive participation for studentid: ${student.id}, subjectid: $subjectId, activeSession: ${activeSession?.id}');
    ref.read(participationRepositoryProvider).addParticipation(
      student.id,
      subjectId,
      true,
      sessionId: activeSession?.id,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Positive Mitarbeit: ${student.firstName} ${student.lastName}'),
        backgroundColor: Colors.green,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _showNegativeMenu(BuildContext context, WidgetRef ref, Student student, Stream<List<NegativeBehavior>> behaviorsStream, ProtocolSession? activeSession) {
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
                   print('Logging negative participation for studentid: ${student.id}, subjectid: $subjectId, activeSession: ${activeSession?.id}');
                  ref.read(participationRepositoryProvider).addParticipation(
                    student.id,
                    subjectId,
                    false,
                    behaviorId: behavior.id,
                    sessionId: activeSession?.id,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${student.shortCode}: ${behavior.description}'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
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

  Future<void> _endSession(BuildContext context, WidgetRef ref, int sessionId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stunde beenden'),
        content: const Text('Möchten Sie die Unterrichtseinheit wirklich beenden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Beenden'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(participationRepositoryProvider).endSession(sessionId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unterrichtseinheit beendet'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
