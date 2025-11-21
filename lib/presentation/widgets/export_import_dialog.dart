import 'package:flutter/material.dart';

class ExportImportDialog extends StatefulWidget {
  final String title;
  final String content;

  const ExportImportDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<ExportImportDialog> createState() => _ExportImportDialogState();
}

class _ExportImportDialogState extends State<ExportImportDialog> {
  bool _includeParticipations = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.content),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Mitarbeitsaufzeichnungen einbeziehen?'),
            value: _includeParticipations,
            onChanged: (value) {
              setState(() {
                _includeParticipations = value ?? false;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_includeParticipations),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
