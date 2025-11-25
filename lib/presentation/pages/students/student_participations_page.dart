import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../templates/base_page_template.dart';
import '../../organisms/lists/student_participations_list.dart';

class StudentParticipationsPage extends ConsumerStatefulWidget {
  final int studentId;
  final String studentName;
  final String studentShortCode;

  const StudentParticipationsPage({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.studentShortCode,
  });

  @override
  ConsumerState<StudentParticipationsPage> createState() => _StudentParticipationsPageState();
}

class _StudentParticipationsPageState extends ConsumerState<StudentParticipationsPage> {
  @override
  Widget build(BuildContext context) {
    return BasePageTemplate(
      title: Platform.isWindows 
          ? 'Protokolleinträge - ${widget.studentName}' 
          : 'Protokolleinträge - ${widget.studentShortCode}',
      body: StudentParticipationsList(
        studentId: widget.studentId,
        onChanged: () => setState(() {}),
      ),
    );
  }
}
