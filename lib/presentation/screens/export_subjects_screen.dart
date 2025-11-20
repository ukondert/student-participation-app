import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';
import '../../core/utils/csv_exporter.dart';
import 'settings_screen.dart';

class ExportSubjectsScreen extends ConsumerWidget {
  const ExportSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsStream = ref.watch(classRepositoryProvider).watchAllSubjects();
    final classesStream = ref.watch(classRepositoryProvider).watchClasses();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export'),
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
              child: Text('Keine Fächer vorhanden.'),
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
                      leading: const Icon(Icons.download, color: Colors.blue),
                      title: Text(subject.name),
                      subtitle: Text(schoolClass?.name ?? 'Unbekannte Klasse'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _exportSubjectData(context, ref, subject, schoolClass),
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

  Future<void> _exportSubjectData(
    BuildContext context,
    WidgetRef ref,
    Subject subject,
    SchoolClass? schoolClass,
  ) async {
    if (schoolClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Klasse nicht gefunden'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final students = await ref.read(classRepositoryProvider).watchStudents(subject.classId).first;
      final participations = await ref.read(participationRepositoryProvider).getParticipationsForSubject(subject.id);

      // Close loading dialog
      if (context.mounted) Navigator.pop(context);

      await CsvExporter.exportSubjectData(
        className: schoolClass.name,
        subjectName: subject.name,
        students: students,
        participations: participations,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export erfolgreich: ${subject.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) Navigator.pop(context);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export fehlgeschlagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
