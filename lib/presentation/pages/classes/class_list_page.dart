import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/entities.dart';
import '../../templates/list_page_template.dart';
import '../../molecules/states/state_components.dart';
import '../../providers/providers.dart';
import 'class_form_page.dart';
import '../subjects/subject_list_page.dart';
import '../../screens/settings_screen.dart';

/// Class List Page
/// 
/// Displays a list of all classes using the ListPageTemplate.
class ClassListPage extends ConsumerWidget {
  const ClassListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classesAsyncValue = ref.watch(classRepositoryProvider).watchClasses();

    return ListPageTemplate(
      title: 'Meine Klassen',
      list: StreamBuilder<List<SchoolClass>>(
        stream: classesAsyncValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorState(
              message: 'Fehler beim Laden der Klassen',
              onRetry: () {
                // Trigger rebuild
                ref.invalidate(classRepositoryProvider);
              },
            );
          }

          if (!snapshot.hasData) {
            return const LoadingState(message: 'Lade Klassen...');
          }

          final classes = snapshot.data!;

          if (classes.isEmpty) {
            return const EmptyState(
              icon: Icons.school_outlined,
              title: 'Keine Klassen vorhanden',
              message: 'Tippe auf +, um eine Klasse hinzuzufügen',
            );
          }

          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final schoolClass = classes[index];
              return _ClassCard(
                schoolClass: schoolClass,
                onTap: () => _navigateToSubjects(context, schoolClass),
                onEdit: () => _navigateToEdit(context, schoolClass),
                onDelete: () => _confirmDelete(context, ref, schoolClass),
              );
            },
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _navigateToSettings(context),
        ),
      ],
      onAdd: () => _navigateToAdd(context),
      addButtonLabel: 'Klasse hinzufügen',
    );
  }

  void _navigateToSubjects(BuildContext context, SchoolClass schoolClass) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubjectListPage(
          classId: schoolClass.id,
          className: schoolClass.name,
        ),
      ),
    );
  }

  void _navigateToEdit(BuildContext context, SchoolClass schoolClass) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClassFormPage(schoolClass: schoolClass),
      ),
    );
  }

  void _navigateToAdd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ClassFormPage(),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    SchoolClass schoolClass,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${schoolClass.name} löschen?'),
        content: const Text(
          'Alle Schüler und Daten dieser Klasse werden unwiderruflich gelöscht.',
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
      ref.read(classRepositoryProvider).deleteClass(schoolClass.id);
    }
  }
}

/// Class Card Widget
/// 
/// Displays a single class with its details and actions.
class _ClassCard extends StatelessWidget {
  final SchoolClass schoolClass;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ClassCard({
    required this.schoolClass,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(schoolClass.name),
        subtitle: _buildSubtitle(),
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

  Widget? _buildSubtitle() {
    final parts = [
      if (schoolClass.teacher != null) schoolClass.teacher,
      if (schoolClass.room != null) schoolClass.room,
      if (schoolClass.schoolYear != null) schoolClass.schoolYear,
    ].whereType<String>().toList();

    if (parts.isEmpty) return null;

    return Text(parts.join(' • '));
  }
}
