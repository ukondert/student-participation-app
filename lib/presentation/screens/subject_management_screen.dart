import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';
import 'student_list_screen.dart';
import 'subject_form_screen.dart';

class SubjectManagementScreen extends ConsumerWidget {
  final int classId;
  final String className;

  const SubjectManagementScreen({super.key, required this.classId, required this.className});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsyncValue = ref.watch(classRepositoryProvider).watchSubjects(classId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Fächer: $className'),
      ),
      body: StreamBuilder<List<Subject>>(
        stream: subjectsAsyncValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final subjects = snapshot.data!;

          if (subjects.isEmpty) {
            return const Center(
              child: Text('Keine Fächer vorhanden. Füge eines hinzu!'),
            );
          }

          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(subject.shortName)),
                  title: Text(subject.name),
                  subtitle: subject.notes != null ? Text(subject.notes!) : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _confirmDelete(context, ref, subject),
                  ),
                  onTap: () {
                    // Navigate to Student List / Tracking for this subject
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudentListScreen(
                          classId: classId,
                          subjectId: subject.id,
                          className: className,
                          subjectName: subject.name,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToSubjectForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToSubjectForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubjectFormScreen(classId: classId),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Subject subject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${subject.name} löschen?'),
        content: const Text('Alle Daten zu diesem Fach werden gelöscht.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              ref.read(classRepositoryProvider).deleteSubject(subject.id);
              Navigator.pop(context);
            },
            child: const Text('Löschen', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
