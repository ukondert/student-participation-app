import 'dart:convert';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/i_class_repository.dart';
import '../../domain/repositories/i_participation_repository.dart';

class DataImportService {
  final IClassRepository _repository;
  final IParticipationRepository _participationRepository;

  DataImportService(this._repository, this._participationRepository);

  Future<void> importData(String jsonString, {bool includeParticipations = false}) async {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    
    // Validate version if needed, for now just proceed
    
    final List<dynamic> classesJson = data['classes'] ?? [];
    final List<dynamic> subjectsJson = data['subjects'] ?? [];
    final List<dynamic> studentsJson = data['students'] ?? [];
    final List<dynamic> participationsJson = data['participations'] ?? [];

    // Map old Class ID -> New Class ID
    final Map<int, int> classIdMap = {};
    // Map old Subject ID -> New Subject ID
    final Map<int, int> subjectIdMap = {};
    // Map old Student ID -> New Student ID
    final Map<int, int> studentIdMap = {};

    // 1. Import Classes
    for (final c in classesJson) {
      final oldId = c['id'] as int;
      final newId = await _repository.addClass(
        c['name'],
        c['teacher'],
        c['room'],
        c['schoolYear'],
      );
      classIdMap[oldId] = newId;
    }

    // 2. Import Subjects
    for (final s in subjectsJson) {
      final oldClassId = s['classId'] as int;
      if (classIdMap.containsKey(oldClassId)) {
        final newSubjectId = await _repository.addSubject(
          s['name'],
          s['shortName'],
          s['notes'],
          classIdMap[oldClassId]!,
        );
        subjectIdMap[s['id'] as int] = newSubjectId;
      }
    }

    // 3. Import Students
    for (final s in studentsJson) {
      final oldClassId = s['classId'] as int;
      if (classIdMap.containsKey(oldClassId)) {
        final newStudentId = await _repository.addStudent(
          s['firstName'],
          s['lastName'],
          s['photoPath'],
          s['shortCode'],
          classIdMap[oldClassId]!,
        );
        studentIdMap[s['id'] as int] = newStudentId;
      }
    }

    // 4. Import Participations
    if (includeParticipations) {
      for (final p in participationsJson) {
        final oldStudentId = p['studentId'] as int;
        final oldSubjectId = p['subjectId'] as int;

        if (studentIdMap.containsKey(oldStudentId) && subjectIdMap.containsKey(oldSubjectId)) {
          await _participationRepository.addParticipation(
            studentIdMap[oldStudentId]!,
            subjectIdMap[oldSubjectId]!,
            p['isPositive'] as bool,
            note: p['note'] as String?,
            behaviorId: p['behaviorId'] as int?,
          );
        }
      }
    }
  }
}
