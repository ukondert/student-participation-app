import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';
import '../../core/utils/csv_exporter.dart';
import 'student_form_screen.dart';
import 'student_detail_screen.dart'; // Will create this

class StudentListScreen extends ConsumerWidget {
  final int classId;
  final int subjectId;
  final String className;
  final String subjectName;

  const StudentListScreen({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.className,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsyncValue = ref.watch(classRepositoryProvider).watchStudents(classId);

    return Scaffold(
      appBar: AppBar(
        title: Text('$className - $subjectName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final students = await ref.read(classRepositoryProvider).watchStudents(classId).first;
              final participations = await ref.read(participationRepositoryProvider).getParticipationsForSubject(subjectId);
              
              if (context.mounted) {
                await CsvExporter.exportSubjectData(
                  className: className,
                  subjectName: subjectName,
                  students: students,
                  participations: participations,
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Student>>(
        stream: studentsAsyncValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data!;

          if (students.isEmpty) {
            return const Center(
              child: Text('Keine Schüler in dieser Klasse.'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Adjust based on screen size
              childAspectRatio: 0.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: students.length,
            itemBuilder: (context, index) {
              return StudentCard(
                student: students[index],
                subjectId: subjectId,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StudentFormScreen(classId: classId)),
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

class StudentCard extends ConsumerWidget {
  final Student student;
  final int subjectId;

  const StudentCard({super.key, required this.student, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We could watch participation count here to show stats on the card
    // For now, just the tracking logic
    
    return InkWell(
      onTap: () {
        // Positive Participation
        ref.read(participationRepositoryProvider).addParticipation(
          student.id,
          subjectId,
          true,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${student.firstName}: +1 Mitarbeit'),
            duration: const Duration(milliseconds: 500),
            backgroundColor: Colors.green,
          ),
        );
      },
      onLongPress: () {
        _showNegativeBehaviorMenu(context, ref);
      },
      onDoubleTap: () {
         Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StudentDetailScreen(student: student, subjectId: subjectId)),
          );
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: student.photoPath != null ? FileImage(File(student.photoPath!)) : null,
              child: student.photoPath == null ? Text(student.shortCode) : null,
            ),
            const SizedBox(height: 8),
            Text(
              '${student.firstName} ${student.lastName}',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showNegativeBehaviorMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final behaviorsAsync = ref.watch(participationRepositoryProvider).watchNegativeBehaviors();
            return StreamBuilder<List<NegativeBehavior>>(
              stream: behaviorsAsync,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final behaviors = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: behaviors.length,
                  itemBuilder: (context, index) {
                    final behavior = behaviors[index];
                    return ListTile(
                      title: Text(behavior.description),
                      onTap: () {
                        ref.read(participationRepositoryProvider).addParticipation(
                          student.id,
                          subjectId,
                          false,
                          behaviorId: behavior.id,
                          note: behavior.description,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${student.firstName}: ${behavior.description}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
