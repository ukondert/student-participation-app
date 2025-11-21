import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';

/// Wiederverwendbares Widget zur Anzeige einer Liste von Fächern mit ihren Klassen
class SubjectListWidget extends ConsumerWidget {
  /// Callback, der beim Antippen eines Fachs aufgerufen wird
  final void Function(BuildContext context, Subject subject, SchoolClass? schoolClass) onSubjectTap;
  
  /// Text, der angezeigt wird, wenn keine Fächer vorhanden sind
  final String emptyMessage;
  
  /// Optional: Benutzerdefiniertes leading Icon für die ListTile
  final Widget? Function(Subject subject)? leadingBuilder;
  
  /// Optional: Benutzerdefiniertes trailing Icon für die ListTile
  final Widget? Function(Subject subject)? trailingBuilder;

  const SubjectListWidget({
    super.key,
    required this.onSubjectTap,
    this.emptyMessage = 'Keine Fächer vorhanden.',
    this.leadingBuilder,
    this.trailingBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsStream = ref.watch(classRepositoryProvider).watchAllSubjects();
    final classesStream = ref.watch(classRepositoryProvider).watchClasses();

    return StreamBuilder<List<Subject>>(
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
          return Center(
            child: Text(emptyMessage),
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
                    leading: leadingBuilder != null 
                        ? leadingBuilder!(subject) 
                        : CircleAvatar(child: Text(subject.shortName)),
                    title: Text(subject.name),
                    subtitle: Text(schoolClass?.name ?? 'Unbekannte Klasse'),
                    trailing: trailingBuilder != null
                        ? trailingBuilder!(subject)
                        : const Icon(Icons.arrow_forward_ios),
                    onTap: () => onSubjectTap(context, subject, schoolClass),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
