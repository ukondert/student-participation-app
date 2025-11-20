import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';
import 'student_participations_screen.dart';

class StudentFormScreen extends ConsumerStatefulWidget {
  final int classId;
  final Student? student;

  const StudentFormScreen({super.key, required this.classId, this.student});

  @override
  ConsumerState<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends ConsumerState<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _shortCodeController;
  String? _photoPath;
  bool _isShortCodeManuallyEdited = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.student?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.student?.lastName ?? '');
    _shortCodeController = TextEditingController(text: widget.student?.shortCode ?? '');
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
          _shortCodeController.text != lastName.substring(0, 1).toUpperCase()) {
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
    final pickedFile = await picker.pickImage(source: ImageSource.camera); // Or gallery
    if (pickedFile != null) {
      setState(() {
        _photoPath = pickedFile.path;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Neuer Schüler' : 'Schüler bearbeiten'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _photoPath != null ? FileImage(File(_photoPath!)) : null,
                    child: _photoPath == null ? const Icon(Icons.camera_alt, size: 40) : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Vorname *'),
                validator: (value) => value == null || value.isEmpty ? 'Bitte Vornamen eingeben' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Nachname *'),
                validator: (value) => value == null || value.isEmpty ? 'Bitte Nachnamen eingeben' : null,
              ),
              TextFormField(
                controller: _shortCodeController,
                decoration: const InputDecoration(labelText: 'Kürzel (3 Zeichen) *'),
                validator: (value) => value == null || value.isEmpty ? 'Bitte Kürzel eingeben' : null,
              ),
              const SizedBox(height: 20),
              if (widget.student != null)
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudentParticipationsScreen(
                          studentId: widget.student!.id,
                          studentName: '${widget.student!.firstName} ${widget.student!.lastName}',
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
              if (widget.student != null) const SizedBox(height: 20),
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
