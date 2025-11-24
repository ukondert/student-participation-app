import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';


/// Reusable widget to display a list of students in a ListView format.
/// Used across different screens to maintain consistent student display.
class StudentListWidget extends StatelessWidget {
  final List<Student> students;
  final int classId;
  final Function(Student) onStudentTap;
  final Function(Student) onEdit;

  const StudentListWidget({
    super.key,
    required this.students,
    required this.classId,
    required this.onStudentTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
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
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => onEdit(student),
            ),
            onTap: () => onStudentTap(student),
          ),
        );
      },
    );
  }
}
