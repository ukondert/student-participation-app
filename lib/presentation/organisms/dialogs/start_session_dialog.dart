import 'package:flutter/material.dart';

/// Dialog to start a new protocol session with optional metadata
class StartSessionDialog extends StatefulWidget {
  final String subjectName;

  const StartSessionDialog({
    super.key,
    required this.subjectName,
  });

  @override
  State<StartSessionDialog> createState() => _StartSessionDialogState();
}

class _StartSessionDialogState extends State<StartSessionDialog> {
  final _topicController = TextEditingController();
  final _notesController = TextEditingController();
  final _homeworkController = TextEditingController();

  @override
  void dispose() {
    _topicController.dispose();
    _notesController.dispose();
    _homeworkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Unterrichtseinheit starten\n${widget.subjectName}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Optional: Fügen Sie Details zur Stunde hinzu',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(
                labelText: 'Thema der Stunde',
                hintText: 'z.B. Quadratische Gleichungen',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notizen zum Inhalt',
                hintText: 'z.B. Einführung in pq-Formel',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _homeworkController,
              decoration: const InputDecoration(
                labelText: 'Hausaufgaben',
                hintText: 'z.B. Übungen S. 42',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, SessionData(
              topic: _topicController.text.isEmpty ? null : _topicController.text,
              notes: _notesController.text.isEmpty ? null : _notesController.text,
              homework: _homeworkController.text.isEmpty ? null : _homeworkController.text,
            ));
          },
          child: const Text('Stunde beginnen'),
        ),
      ],
    );
  }
}

/// Data class for session metadata
class SessionData {
  final String? topic;
  final String? notes;
  final String? homework;

  SessionData({
    this.topic,
    this.notes,
    this.homework,
  });
}