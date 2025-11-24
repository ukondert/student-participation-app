import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/entities.dart';
import '../../templates/form_page_template.dart';
import '../../atoms/buttons/primary_button.dart';
import '../../providers/providers.dart';

/// Class Form Page
/// 
/// Form for creating or editing a class using FormPageTemplate.
class ClassFormPage extends ConsumerStatefulWidget {
  final SchoolClass? schoolClass;

  const ClassFormPage({super.key, this.schoolClass});

  @override
  ConsumerState<ClassFormPage> createState() => _ClassFormPageState();
}

class _ClassFormPageState extends ConsumerState<ClassFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _teacherController;
  late TextEditingController _roomController;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.schoolClass?.name ?? '');
    _teacherController = TextEditingController(text: widget.schoolClass?.teacher ?? '');
    _roomController = TextEditingController(text: widget.schoolClass?.room ?? '');
    _yearController = TextEditingController(text: widget.schoolClass?.schoolYear ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teacherController.dispose();
    _roomController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormPageTemplate(
      title: widget.schoolClass == null ? 'Neue Klasse' : 'Klasse bearbeiten',
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Klassenname *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Bitte Namen eingeben' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _teacherController,
              decoration: const InputDecoration(
                labelText: 'Klassenvorstand (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _roomController,
              decoration: const InputDecoration(
                labelText: 'Raum (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _yearController,
              decoration: const InputDecoration(
                labelText: 'Schuljahr (optional)',
                border: OutlineInputBorder(),
              ),
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
      final teacher = _teacherController.text.isEmpty ? null : _teacherController.text;
      final room = _roomController.text.isEmpty ? null : _roomController.text;
      final year = _yearController.text.isEmpty ? null : _yearController.text;

      if (widget.schoolClass == null) {
        // Add new class
        ref.read(classRepositoryProvider).addClass(name, teacher, room, year);
      } else {
        // Update existing class
        ref.read(classRepositoryProvider).updateClass(
              SchoolClass(
                id: widget.schoolClass!.id,
                name: name,
                teacher: teacher,
                room: room,
                schoolYear: year,
              ),
            );
      }
      Navigator.pop(context);
    }
  }
}
