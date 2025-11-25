class SchoolClass {
  final int id;
  final String name;
  final String? teacher;
  final String? room;
  final String? schoolYear;

  SchoolClass({
    required this.id,
    required this.name,
    this.teacher,
    this.room,
    this.schoolYear,
  });
}

class Subject {
  final int id;
  final String name;
  final String shortName;
  final String? notes;
  final int classId;

  Subject({
    required this.id,
    required this.name,
    required this.shortName,
    this.notes,
    required this.classId,
  });
}

class Student {
  final int id;
  final String firstName;
  final String lastName;
  final String? photoPath;
  final String shortCode;
  final int classId;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.photoPath,
    required this.shortCode,
    required this.classId,
  });
}

class NegativeBehavior {
  final int id;
  final String description;

  NegativeBehavior({
    required this.id,
    required this.description,
  });
}

class Participation {
  final int id;
  final int studentId;
  final int subjectId;
  final DateTime date;
  final bool isPositive;
  final String? note;
  final int? behaviorId;
  final int? sessionId;

  Participation({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.date,
    required this.isPositive,
    this.note,
    this.behaviorId,
    this.sessionId,
  });
}

class ProtocolSession {
  final int id;
  final int subjectId;
  final DateTime startTime;
  final DateTime? endTime;
  final String? topic;
  final String? notes;
  final String? homework;

  ProtocolSession({
    required this.id,
    required this.subjectId,
    required this.startTime,
    this.endTime,
    this.topic,
    this.notes,
    this.homework,
  });
}

/// View model combining participation data with related entities for display.
/// This reduces UI complexity by pre-joining related data.
class ParticipationWithDetails {
  final Participation participation;
  final String description;
  final ProtocolSession? session;
  final NegativeBehavior? behavior;

  ParticipationWithDetails({
    required this.participation,
    required this.description,
    this.session,
    this.behavior,
  });
}
