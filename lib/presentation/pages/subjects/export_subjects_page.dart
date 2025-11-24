import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../templates/list_page_template.dart';
import '../../widgets/subject_list_widget.dart';
import '../../../core/utils/csv_exporter.dart';
import '../settings/settings_page.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';

class ExportSubjectsPage extends ConsumerWidget {
  const ExportSubjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListPageTemplate(
      title: 'Export',
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
      list: SubjectListWidget(
        leadingBuilder: (_) => const Icon(Icons.download, color: Colors.blue),
        onSubjectTap: (context, subject, schoolClass) {
          _exportSubjectData(context, ref, subject, schoolClass);
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
