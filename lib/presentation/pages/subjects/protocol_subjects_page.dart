import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../templates/list_page_template.dart';
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
        onSubjectTap: (context, subject, schoolClass) {
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
        },
      ),
    );
  }
}
