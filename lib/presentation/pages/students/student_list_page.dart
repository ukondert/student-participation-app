import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_participation_app/core/utils/csv_exporter.dart';
import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/presentation/molecules/states/state_components.dart';
import 'package:student_participation_app/presentation/pages/students/student_detail_page.dart';
import 'package:student_participation_app/presentation/pages/students/student_form_page.dart';
import 'package:student_participation_app/presentation/providers/providers.dart';
import 'package:student_participation_app/presentation/templates/list_page_template.dart';
import 'package:student_participation_app/presentation/widgets/student_list_widget.dart';

class StudentListPage extends ConsumerWidget {
  final int classId;
  final int subjectId;
  final String className;
  final String subjectName;

  const StudentListPage({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.className,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsyncValue = ref.watch(classRepositoryProvider).watchStudents(classId);

    return ListPageTemplate(
      title: '$className - $subjectName',
      actions: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => _exportData(context, ref),
          tooltip: 'Exportieren',
        ),
      ],
      list: StreamBuilder<List<Student>>(
        stream: studentsAsyncValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorState(
              message: 'Fehler beim Laden der Schüler',
              onRetry: () {
                ref.invalidate(classRepositoryProvider);
              },
            );
          }

          if (!snapshot.hasData) {
            return const LoadingState(message: 'Lade Schüler...');
          }

          final students = snapshot.data!;

          if (students.isEmpty) {
            return const EmptyState(
              icon: Icons.people_outline,
              title: 'Keine Schüler vorhanden',
              message: 'Tippe auf +, um einen Schüler hinzuzufügen',
            );
          }

          return StudentListWidget(
            students: students,
            classId: classId,
            onStudentTap: (student) => _navigateToStudentDetail(context, student),
            onEdit: (student) => _navigateToStudentForm(context, student),
          );
        },
      ),
      onAdd: () => _navigateToStudentForm(context, null),
      addButtonLabel: 'Schüler hinzufügen',
    );
  }

  void _navigateToStudentDetail(BuildContext context, Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentDetailPage(
          student: student,
          subjectId: subjectId,
        ),
      ),
    );
  }

  void _navigateToStudentForm(BuildContext context, Student? student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentFormPage(
          classId: classId,
          student: student,
        ),
      ),
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    try {
      final students = await ref.read(classRepositoryProvider).watchStudents(classId).first;
      final participations = await ref.read(participationRepositoryProvider).getParticipationsForSubject(subjectId);
      
      if (context.mounted) {
        await CsvExporter.exportSubjectData(
          className: className,
          subjectName: subjectName,
          students: students,
          participations: participations,
        );
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Export erfolgreich')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Export: $e')),
        );
      }
    }
  }
}
