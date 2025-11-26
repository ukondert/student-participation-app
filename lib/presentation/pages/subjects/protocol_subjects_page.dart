import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../templates/list_page_template.dart';
import '../../organisms/dialogs/start_session_dialog.dart';
import '../../widgets/subject_list_widget.dart';
import '../protocols/protocol_tracking_page.dart';
import '../settings/settings_page.dart';

class ProtocolSubjectsPage extends ConsumerWidget {
  const ProtocolSubjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListPageTemplate(
      title: 'Protokoll',
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
        ),
      ],
      list: SubjectListWidget(
        onSubjectTap: (context, subject, schoolClass) async {
          final repository = ref.read(participationRepositoryProvider);
          
          // Check for active session first
          final activeSession = await repository.getActiveSession(subject.id);
          
          if (activeSession != null) {
            // Navigate directly if session exists
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProtocolTrackingPage(
                    classId: subject.classId,
                    subjectId: subject.id,
                    className: schoolClass?.name ?? '',
                    subjectName: subject.name,
                    subjectShortName: subject.shortName,
                  ),
                ),
              );
            }
            return;
          }

          // Show dialog to optionally enter session details
          if (!context.mounted) return;
          final sessionData = await showDialog<SessionData>(
            context: context,
            builder: (_) => StartSessionDialog(subjectName: subject.name),
          );

          // If user cancelled, don't navigate
          if (sessionData == null) return;

          // Start the session in the background
          await repository.startSession(
            subject.id,
            topic: sessionData.topic,
            notes: sessionData.notes,
            homework: sessionData.homework,
          );

          // Navigate to tracking page
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProtocolTrackingPage(
                  classId: subject.classId,
                  subjectId: subject.id,
                  className: schoolClass?.name ?? '',
                  subjectName: subject.name,
                  subjectShortName: subject.shortName,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
