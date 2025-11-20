import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';
import 'class_form_screen.dart';
import 'subject_management_screen.dart';
import 'settings_screen.dart';

class ClassListScreen extends ConsumerWidget {
  const ClassListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classesAsyncValue = ref.watch(classRepositoryProvider).watchClasses();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Klassen'),
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
      body: StreamBuilder<List<SchoolClass>>(
        stream: classesAsyncValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final classes = snapshot.data!;

          if (classes.isEmpty) {
            return const Center(
              child: Text('Keine Klassen vorhanden. Tippe auf +, um eine hinzuzufügen.'),
            );
          }

          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final schoolClass = classes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(schoolClass.name),
                  subtitle: Text(
                    [
                      if (schoolClass.teacher != null) schoolClass.teacher,
                      if (schoolClass.room != null) schoolClass.room,
                      if (schoolClass.schoolYear != null) schoolClass.schoolYear,
                    ].whereType<String>().join(' • '),
                  ),
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
                         Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ClassFormScreen(schoolClass: schoolClass)),
                        );
                      } else if (value == 'delete') {
                        _confirmDelete(context, ref, schoolClass);
                      }
                    },
                  ),
                  onTap: () {
                    // Navigate to Subject Management or directly to tracking if only one subject?
                    // For now, let's go to Subject Management (or Class Details)
                    // Or maybe we should select a subject to start tracking.
                    // Let's assume we go to a screen where we see subjects for this class.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SubjectManagementScreen(classId: schoolClass.id, className: schoolClass.name)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ClassFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, SchoolClass schoolClass) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${schoolClass.name} löschen?'),
        content: const Text('Alle Schüler und Daten dieser Klasse werden unwiderruflich gelöscht.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              ref.read(classRepositoryProvider).deleteClass(schoolClass.id);
              Navigator.pop(context);
            },
            child: const Text('Löschen', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
