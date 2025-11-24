import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/presentation/atoms/buttons/primary_button.dart';
import 'package:student_participation_app/presentation/providers/providers.dart';
import 'package:student_participation_app/presentation/screens/student_participations_screen.dart';
import 'package:student_participation_app/presentation/templates/form_page_template.dart';

class StudentFormPage extends ConsumerStatefulWidget {
  final int classId;
  final Student? student;

  const StudentFormPage({
    super.key,
    required this.classId,
    this.student,
  });

  @override
  ConsumerState<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends ConsumerState<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _shortCodeController;
  String? _photoPath;
  bool _isShortCodeManuallyEdited = false;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.student?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.student?.lastName ?? '');
    _shortCodeController =
        TextEditingController(text: widget.student?.shortCode ?? '');
    _photoPath = widget.student?.photoPath;

    // Auto-generate short code listener
    _lastNameController.addListener(_updateShortCode);
    _shortCodeController.addListener(_onShortCodeChanged);
  }

  void _onShortCodeChanged() {
    // Mark as manually edited if user types in the shortcode field
    if (_shortCodeController.text.isNotEmpty && widget.student == null) {
      final lastName = _lastNameController.text;
      final expectedCode = lastName.length >= 3
          ? lastName.substring(0, 3).toUpperCase()
          : lastName.toUpperCase();

      // Only mark as manually edited if it differs from auto-generated value
      if (_shortCodeController.text != expectedCode &&
          _shortCodeController.text !=
              lastName.substring(0, 1).toUpperCase()) {
        _isShortCodeManuallyEdited = true;
      }
    }
  }

  void _updateShortCode() {
    if (widget.student == null && !_isShortCodeManuallyEdited) {
      final lastName = _lastNameController.text;
      if (lastName.length >= 3) {
        _shortCodeController.text = lastName.substring(0, 3).toUpperCase();
      } else if (lastName.isNotEmpty) {
        _shortCodeController.text = lastName.toUpperCase();
      } else {
        _shortCodeController.text = '';
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.removeListener(_updateShortCode);
    _lastNameController.dispose();
    _shortCodeController.removeListener(_onShortCodeChanged);
    _shortCodeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _photoPath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormPageTemplate(
      title: widget.student == null ? 'Neuer Schüler' : 'Schüler bearbeiten',
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _photoPath != null ? FileImage(File(_photoPath!)) : null,
                  child: _photoPath == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Vorname *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Bitte Vornamen eingeben'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Nachname *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Bitte Nachnamen eingeben'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _shortCodeController,
              decoration: const InputDecoration(
                labelText: 'Kürzel (3 Zeichen) *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Bitte Kürzel eingeben'
                  : null,
            ),
            const SizedBox(height: 24),
            if (widget.student != null) ...[
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudentParticipationsScreen(
                        studentId: widget.student!.id,
                        studentName:
                            '${widget.student!.firstName} ${widget.student!.lastName}',
                        studentShortCode: widget.student!.shortCode,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text('Protokolleinträge'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 24),
            ],
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
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final shortCode = _shortCodeController.text;

      if (widget.student == null) {
        ref.read(classRepositoryProvider).addStudent(
              firstName,
              lastName,
              _photoPath,
              shortCode,
              widget.classId,
            );
      } else {
        ref.read(classRepositoryProvider).updateStudent(Student(
              id: widget.student!.id,
              firstName: firstName,
              lastName: lastName,
              photoPath: _photoPath,
              shortCode: shortCode,
              classId: widget.classId,
            ));
      }
      Navigator.pop(context);
    }
  }
}
