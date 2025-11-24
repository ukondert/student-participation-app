import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/entities.dart';
import '../../templates/list_page_template.dart';
import '../../molecules/states/state_components.dart';
import '../../providers/providers.dart';
import 'subject_form_page.dart';
import '../../pages/students/student_list_page.dart';

/// Subject List Page
/// 
/// Displays a list of subjects for a specific class using ListPageTemplate.
class SubjectListPage extends ConsumerWidget {
  final int classId;
  final String className;

  const SubjectListPage({
    super.key,
    required this.classId,
    required this.className,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsyncValue = ref.watch(classRepositoryProvider).watchSubjects(classId);

    return ListPageTemplate(
      title: 'Fächer: $className',
      list: StreamBuilder<List<Subject>>(
        stream: subjectsAsyncValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorState(
              message: 'Fehler beim Laden der Fächer',
              onRetry: () {
                // Trigger rebuild
                ref.invalidate(classRepositoryProvider);
              },
            );
          }

          if (!snapshot.hasData) {
            return const LoadingState(message: 'Lade Fächer...');
          }

          final subjects = snapshot.data!;

          if (subjects.isEmpty) {
            return const EmptyState(
              icon: Icons.book_outlined,
              title: 'Keine Fächer vorhanden',
              message: 'Tippe auf +, um ein Fach hinzuzufügen',
            );
          }

          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return _SubjectCard(
                subject: subject,
                onTap: () => _navigateToStudents(context, subject),
                onEdit: () => _navigateToEdit(context, subject),
                onDelete: () => _confirmDelete(context, ref, subject),
              );
            },
          );
        },
      ),
      onAdd: () => _navigateToAdd(context),
      addButtonLabel: 'Fach hinzufügen',
    );
  }

  void _navigateToStudents(BuildContext context, Subject subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentListPage(
          classId: classId,
          subjectId: subject.id,
          className: className,
          subjectName: subject.name,
        ),
      ),
    );
  }

  void _navigateToEdit(BuildContext context, Subject subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubjectFormPage(
          classId: classId,
          subject: subject,
        ),
      ),
    );
  }

  void _navigateToAdd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubjectFormPage(classId: classId),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Subject subject,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${subject.name} löschen?'),
        content: const Text(
          'Alle Daten zu diesem Fach werden unwiderruflich gelöscht.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ref.read(classRepositoryProvider).deleteSubject(subject.id);
    }
  }
}

/// Subject Card Widget
/// 
/// Displays a single subject with its details and actions.
class _SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SubjectCard({
    required this.subject,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(subject.shortName),
        ),
        title: Text(subject.name),
        subtitle: subject.notes != null && subject.notes!.isNotEmpty
            ? Text(subject.notes!)
            : null,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Bearbeiten'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Löschen'),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
        ),
        onTap: onTap,
      ),
    );
  }
}
