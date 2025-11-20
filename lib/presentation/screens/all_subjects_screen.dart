import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';
import 'subject_students_screen.dart';
import 'settings_screen.dart';

class AllSubjectsScreen extends ConsumerWidget {
  const AllSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsStream = ref.watch(classRepositoryProvider).watchAllSubjects();
    final classesStream = ref.watch(classRepositoryProvider).watchClasses();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alle Fächer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Subject>>(
        stream: subjectsStream,
        builder: (context, subjectSnapshot) {
          if (subjectSnapshot.hasError) {
            return Center(child: Text('Error: ${subjectSnapshot.error}'));
          }
          if (!subjectSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final subjects = subjectSnapshot.data!;

          if (subjects.isEmpty) {
            return const Center(
              child: Text('Keine Fächer vorhanden. Erstelle zuerst eine Klasse und füge Fächer hinzu.'),
            );
          }

          return StreamBuilder<List<SchoolClass>>(
            stream: classesStream,
            builder: (context, classSnapshot) {
              if (!classSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final classes = classSnapshot.data!;
              final classMap = {for (var c in classes) c.id: c};

              return ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  final schoolClass = classMap[subject.classId];

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(subject.shortName)),
                      title: Text(subject.name),
                      subtitle: Text(schoolClass?.name ?? 'Unbekannte Klasse'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubjectStudentsScreen(
                              classId: subject.classId,
                              subjectId: subject.id,
                              className: schoolClass?.name ?? '',
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
          );
        },
      ),
    );
  }
}
