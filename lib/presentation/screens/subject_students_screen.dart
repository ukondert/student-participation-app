import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';
import 'student_form_screen.dart';
import 'settings_screen.dart';

class SubjectStudentsScreen extends ConsumerWidget {
  final int classId;
  final int subjectId;
  final String className;
  final String subjectName;
  final String subjectShortName;

  const SubjectStudentsScreen({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.className,
    required this.subjectName,
    required this.subjectShortName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsStream = ref.watch(classRepositoryProvider).watchStudents(classId);

    return Scaffold(
      appBar: AppBar(
        title: Text(Platform.isWindows 
            ? '$subjectName - Schüler' 
            : '$subjectShortName - Schüler'),
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
      body: StreamBuilder<List<Student>>(
        stream: studentsStream,
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
              child: Text('Keine Schüler. Füge welche hinzu!'),
            );
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: student.photoPath != null 
                        ? FileImage(File(student.photoPath!)) 
                        : null,
                    child: student.photoPath == null 
                        ? Text(student.shortCode) 
                        : null,
                  ),
                  title: Text('${student.firstName} ${student.lastName}'),
                  subtitle: Text('Kürzel: ${student.shortCode}'),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudentFormScreen(
                          classId: classId,
                          student: student,
                        ),
                      ),
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
            MaterialPageRoute(
              builder: (_) => StudentFormScreen(classId: classId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
