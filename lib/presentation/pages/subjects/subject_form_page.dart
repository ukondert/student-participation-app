import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/entities.dart';
import '../../templates/form_page_template.dart';
import '../../atoms/buttons/primary_button.dart';
import '../../providers/providers.dart';

/// Subject Form Page
/// 
/// Form for creating or editing a subject using FormPageTemplate.
class SubjectFormPage extends ConsumerStatefulWidget {
  final int classId;
  final Subject? subject;

  const SubjectFormPage({
    super.key,
    required this.classId,
    this.subject,
  });

  @override
  ConsumerState<SubjectFormPage> createState() => _SubjectFormPageState();
}

class _SubjectFormPageState extends ConsumerState<SubjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _shortNameController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject?.name ?? '');
    _shortNameController = TextEditingController(text: widget.subject?.shortName ?? '');
    _notesController = TextEditingController(text: widget.subject?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shortNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormPageTemplate(
      title: widget.subject == null ? 'Neues Fach' : 'Fach bearbeiten',
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Fachname *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Bitte Namen eingeben' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _shortNameController,
              decoration: const InputDecoration(
                labelText: 'Kürzel *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Bitte Kürzel eingeben' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Anmerkungen (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Speichern',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final shortName = _shortNameController.text;
      final notes = _notesController.text.isEmpty ? null : _notesController.text;

      if (widget.subject == null) {
        // Add new subject
        ref.read(classRepositoryProvider).addSubject(
              name,
              shortName,
              notes,
              widget.classId,
            );
      } else {
        // Update existing subject
        ref.read(classRepositoryProvider).updateSubject(
              Subject(
                id: widget.subject!.id,
                name: name,
                shortName: shortName,
                notes: notes,
                classId: widget.classId,
              ),
            );
      }
      Navigator.pop(context);
    }
  }
}
