import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';

class ClassFormScreen extends ConsumerStatefulWidget {
  final SchoolClass? schoolClass;

  const ClassFormScreen({super.key, this.schoolClass});

  @override
  ConsumerState<ClassFormScreen> createState() => _ClassFormScreenState();
}

class _ClassFormScreenState extends ConsumerState<ClassFormScreen> {
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

  void _save() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final teacher = _teacherController.text.isEmpty ? null : _teacherController.text;
      final room = _roomController.text.isEmpty ? null : _roomController.text;
      final year = _yearController.text.isEmpty ? null : _yearController.text;

      if (widget.schoolClass == null) {
        // Add
        ref.read(classRepositoryProvider).addClass(name, teacher, room, year);
      } else {
        // Update
        ref.read(classRepositoryProvider).updateClass(SchoolClass(
          id: widget.schoolClass!.id,
          name: name,
          teacher: teacher,
          room: room,
          schoolYear: year,
        ));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.schoolClass == null ? 'Neue Klasse' : 'Klasse bearbeiten'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Klassenname *'),
                validator: (value) => value == null || value.isEmpty ? 'Bitte Namen eingeben' : null,
              ),
              TextFormField(
                controller: _teacherController,
                decoration: const InputDecoration(labelText: 'Klassenvorstand (optional)'),
              ),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(labelText: 'Raum (optional)'),
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Schuljahr (optional)'),
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
