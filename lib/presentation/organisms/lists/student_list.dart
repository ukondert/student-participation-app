import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/entities.dart';
import '../../molecules/cards/student_card.dart';
import '../../molecules/states/state_components.dart';

/// Student list organism component
/// 
/// Displays a scrollable list of students with state management.
/// Handles loading, error, and empty states automatically.
class StudentList extends ConsumerWidget {
  final List<Student> students;
  final bool isLoading;
  final String? errorMessage;
  final bool showParticipationCounts;
  final void Function(Student)? onStudentTap;
  final void Function(Student)? onStudentLongPress;
  final VoidCallback? onRetry;
  final VoidCallback? onAddStudent;

  const StudentList({
    super.key,
    required this.students,
    this.isLoading = false,
    this.errorMessage,
    this.showParticipationCounts = false,
    this.onStudentTap,
    this.onStudentLongPress,
    this.onRetry,
    this.onAddStudent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Show error state
    if (errorMessage != null) {
      return ErrorState(
        message: errorMessage!,
        onRetry: onRetry,
      );
    }

    // Show loading state
    if (isLoading) {
      return const LoadingState(
        message: 'Schüler werden geladen...',
      );
    }

    // Show empty state
    if (students.isEmpty) {
      return EmptyState(
        icon: Icons.school,
        title: 'Keine Schüler',
        message: 'Fügen Sie Ihren ersten Schüler hinzu',
        actionLabel: onAddStudent != null ? 'Schüler hinzufügen' : null,
        onAction: onAddStudent,
      );
    }

    // Show student list
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        
        return StudentCard(
          student: student,
          showCounters: showParticipationCounts,
          // TODO: Get actual participation counts from provider
          positiveCount: showParticipationCounts ? 0 : null,
          negativeCount: showParticipationCounts ? 0 : null,
          onTap: onStudentTap != null ? () => onStudentTap!(student) : null,
          onLongPress: onStudentLongPress != null 
              ? () => onStudentLongPress!(student) 
              : null,
        );
      },
    );
  }
}
