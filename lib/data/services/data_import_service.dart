import 'dart:convert';
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
    final List<dynamic> protocolSessionsJson = data['protocolSessions'] ?? [];

    // Fetch existing data to prevent duplicates
    final existingClasses = await _repository.getAllClasses();
    final existingSubjects = await _repository.getAllSubjects();
    final existingStudents = await _repository.getAllStudents();

    // Create lookup maps for faster access
    // Name -> ID
    final Map<String, int> existingClassesMap = {
      for (var c in existingClasses) c.name: c.id
    };
    
    // Composite Key "Name-ClassID" -> ID
    final Map<String, int> existingSubjectsMap = {
      for (var s in existingSubjects) '${s.name}-${s.classId}': s.id
    };

    // Composite Key "FirstName-LastName-ClassID" -> ID
    final Map<String, int> existingStudentsMap = {
      for (var s in existingStudents) '${s.firstName}-${s.lastName}-${s.classId}': s.id
    };

    // Map old Class ID -> New Class ID
    final Map<int, int> classIdMap = {};
    // Map old Subject ID -> New Subject ID
    final Map<int, int> subjectIdMap = {};
    // Map old Student ID -> New Student ID
    final Map<int, int> studentIdMap = {};
    // Map old Session ID -> New Session ID
    final Map<int, int> sessionIdMap = {};

    // 1. Import Classes
    for (final c in classesJson) {
      final oldId = c['id'] as int;
      final name = c['name'] as String;
      
      if (existingClassesMap.containsKey(name)) {
        classIdMap[oldId] = existingClassesMap[name]!;
      } else {
        final newId = await _repository.addClass(
          name,
          c['teacher'],
          c['room'],
          c['schoolYear'],
        );
        classIdMap[oldId] = newId;
        // Update map for subsequent lookups (though names should be unique in import)
        existingClassesMap[name] = newId; 
      }
    }

    // 2. Import Subjects
    for (final s in subjectsJson) {
      final oldClassId = s['classId'] as int;
      if (classIdMap.containsKey(oldClassId)) {
        final name = s['name'] as String;
        final newClassId = classIdMap[oldClassId]!;
        final key = '$name-$newClassId';

        if (existingSubjectsMap.containsKey(key)) {
          subjectIdMap[s['id'] as int] = existingSubjectsMap[key]!;
        } else {
          final newSubjectId = await _repository.addSubject(
            name,
            s['shortName'],
            s['notes'],
            newClassId,
          );
          subjectIdMap[s['id'] as int] = newSubjectId;
          existingSubjectsMap[key] = newSubjectId;
        }
      }
    }

    // 3. Import Students
    for (final s in studentsJson) {
      final oldClassId = s['classId'] as int;
      if (classIdMap.containsKey(oldClassId)) {
        final firstName = s['firstName'] as String;
        final lastName = s['lastName'] as String;
        final newClassId = classIdMap[oldClassId]!;
        final key = '$firstName-$lastName-$newClassId';

        if (existingStudentsMap.containsKey(key)) {
          studentIdMap[s['id'] as int] = existingStudentsMap[key]!;
        } else {
          final newStudentId = await _repository.addStudent(
            firstName,
            lastName,
            s['photoPath'],
            s['shortCode'],
            newClassId,
          );
          studentIdMap[s['id'] as int] = newStudentId;
          existingStudentsMap[key] = newStudentId;
        }
      }
    }

    // 4. Import Protocol Sessions (before participations since participations reference sessions)
    if (includeParticipations) {
      for (final s in protocolSessionsJson) {
        final oldSubjectId = s['subjectId'] as int;
        if (subjectIdMap.containsKey(oldSubjectId)) {
          final newSubjectId = subjectIdMap[oldSubjectId]!;
          final startTime = DateTime.parse(s['startTime'] as String);
          final endTimeStr = s['endTime'] as String?;
          final endTime = endTimeStr != null ? DateTime.parse(endTimeStr) : null;

          final newSessionId = await _participationRepository.addSession(
            newSubjectId,
            startTime,
            endTime,
            topic: s['topic'] as String?,
            notes: s['notes'] as String?,
            homework: s['homework'] as String?,
          );
          sessionIdMap[s['id'] as int] = newSessionId;
        }
      }
    }

    // 5. Import Participations
    if (includeParticipations) {
      for (final p in participationsJson) {
        final oldStudentId = p['studentId'] as int;
        final oldSubjectId = p['subjectId'] as int;

        if (studentIdMap.containsKey(oldStudentId) && subjectIdMap.containsKey(oldSubjectId)) {
          final oldSessionId = p['sessionId'] as int?;
          // Only use the new session ID if the old session was successfully imported
          // If the session wasn't found in the map, the participation will be imported without a session reference
          int? newSessionId;
          if (oldSessionId != null && sessionIdMap.containsKey(oldSessionId)) {
            newSessionId = sessionIdMap[oldSessionId];
          }
          
          await _participationRepository.addParticipation(
            studentIdMap[oldStudentId]!,
            subjectIdMap[oldSubjectId]!,
            p['isPositive'] as bool,
            note: p['note'] as String?,
            behaviorId: p['behaviorId'] as int?,
            sessionId: newSessionId,
          );
        }
      }
    }
  }
}
