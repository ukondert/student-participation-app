import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../templates/list_page_template.dart';
import '../../widgets/subject_list_widget.dart';
import '../students/student_list_page.dart';
import '../settings/settings_page.dart';

class AllSubjectsPage extends ConsumerWidget {
  const AllSubjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListPageTemplate(
      title: 'Alle Fächer',
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
