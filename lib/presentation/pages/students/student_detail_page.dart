import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';
import '../../templates/base_page_template.dart';
import '../../organisms/lists/student_participations_list.dart';

class StudentDetailPage extends ConsumerWidget {
  final Student student;
  final int subjectId;

  const StudentDetailPage({
    super.key,
    required this.student,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participationsAsync = ref.watch(participationRepositoryProvider).watchParticipations(student.id, subjectId);

    return BasePageTemplate(
      title: '${student.firstName} ${student.lastName}',
      body: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: student.photoPath != null ? FileImage(File(student.photoPath!)) : null,
            child: student.photoPath == null ? Text(student.shortCode, style: const TextStyle(fontSize: 30)) : null,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<Participation>>(
              stream: participationsAsync,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final participations = snapshot.data!;

                final positiveCount = participations.where((p) => p.isPositive).length;
                final negativeCount = participations.where((p) => !p.isPositive).length;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatCard(label: 'Positiv', count: positiveCount, color: Colors.green),
                        _StatCard(label: 'Negativ', count: negativeCount, color: Colors.red),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: StudentParticipationsList(
                        studentId: student.id,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatCard({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            Text('$count', style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
