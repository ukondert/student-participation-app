import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/subject_list_widget.dart';
import '../pages/students/student_list_page.dart';
import 'settings_screen.dart';

class AllSubjectsScreen extends ConsumerWidget {
  const AllSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: SubjectListWidget(
        emptyMessage: 'Keine Fächer vorhanden. Erstelle zuerst eine Klasse und füge Fächer hinzu.',
        onSubjectTap: (context, subject, schoolClass) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudentListPage(
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
  }
}
