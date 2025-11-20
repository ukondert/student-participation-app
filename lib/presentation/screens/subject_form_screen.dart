import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';

class SubjectFormScreen extends ConsumerStatefulWidget {
  final int classId;
  final Subject? subject;

  const SubjectFormScreen({super.key, required this.classId, this.subject});

  @override
  ConsumerState<SubjectFormScreen> createState() => _SubjectFormScreenState();
}

class _SubjectFormScreenState extends ConsumerState<SubjectFormScreen> {
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

  void _save() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final shortName = _shortNameController.text;
      final notes = _notesController.text.isEmpty ? null : _notesController.text;

      if (widget.subject == null) {
        // Add
        ref.read(classRepositoryProvider).addSubject(name, shortName, notes, widget.classId);
      } else {
        // Update
        ref.read(classRepositoryProvider).updateSubject(Subject(
          id: widget.subject!.id,
          name: name,
          shortName: shortName,
          notes: notes,
          classId: widget.classId,
        ));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject == null ? 'Neues Fach' : 'Fach bearbeiten'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Fachname *'),
                validator: (value) => value == null || value.isEmpty ? 'Bitte Namen eingeben' : null,
              ),
              TextFormField(
                controller: _shortNameController,
                decoration: const InputDecoration(labelText: 'Kürzel *'),
                validator: (value) => value == null || value.isEmpty ? 'Bitte Kürzel eingeben' : null,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Anmerkungen (optional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Speichern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
