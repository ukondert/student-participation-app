import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/subject_list_widget.dart';
import 'protocol_tracking_screen.dart';
import 'settings_screen.dart';

class ProtocolSubjectsScreen extends ConsumerWidget {
  const ProtocolSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protokoll'),
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
      body: SubjectListWidget(
        onSubjectTap: (context, subject, schoolClass) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProtocolTrackingScreen(
                classId: subject.classId,
                subjectId: subject.id,
                className: schoolClass?.name ?? '',
                subjectName: subject.name,
                subjectShortName: subject.shortName,
              ),
            ),
          );
        },
      ),
    );
  }
}
