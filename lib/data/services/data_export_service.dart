import 'dart:convert';
import '../../domain/repositories/i_class_repository.dart';
import '../../domain/repositories/i_participation_repository.dart';

class DataExportService {
  final IClassRepository _repository;
  final IParticipationRepository _participationRepository;

  DataExportService(this._repository, this._participationRepository);

  Future<String> exportData({bool includeParticipations = false}) async {
    final classes = await _repository.getAllClasses();
    final subjects = await _repository.getAllSubjects();
    final students = await _repository.getAllStudents();
    final participations = includeParticipations ? await _participationRepository.getAllParticipations() : [];
    final protocolSessions = includeParticipations ? await _participationRepository.getAllSessions() : [];

    final Map<String, dynamic> data = {
      'version': 1,
      'timestamp': DateTime.now().toIso8601String(),
      'classes': classes.map((c) => {
        'id': c.id,
        'name': c.name,
        'teacher': c.teacher,
        'room': c.room,
        'schoolYear': c.schoolYear,
      }).toList(),
      'subjects': subjects.map((s) => {
        'id': s.id,
        'name': s.name,
        'shortName': s.shortName,
        'notes': s.notes,
        'classId': s.classId,
      }).toList(),
      'students': students.map((s) => {
        'id': s.id,
        'firstName': s.firstName,
        'lastName': s.lastName,
        'photoPath': s.photoPath,
        'shortCode': s.shortCode,
        'classId': s.classId,
      }).toList(),
      if (includeParticipations)
        'participations': participations.map((p) => {
          'id': p.id,
          'studentId': p.studentId,
          'subjectId': p.subjectId,
          'date': p.date.toIso8601String(),
          'isPositive': p.isPositive,
          'note': p.note,
          'behaviorId': p.behaviorId,
          'sessionId': p.sessionId,
        }).toList(),
      if (includeParticipations)
        'protocolSessions': protocolSessions.map((s) => {
          'id': s.id,
          'subjectId': s.subjectId,
          'startTime': s.startTime.toIso8601String(),
          'endTime': s.endTime?.toIso8601String(),
          'topic': s.topic,
          'notes': s.notes,
          'homework': s.homework,
        }).toList(),
    };

    return jsonEncode(data);
  }
}
