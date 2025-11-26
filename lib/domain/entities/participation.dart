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

  factory Participation.fromJson(Map<String, dynamic> json) {
    return Participation(
      id: json['id'] as int,
      studentId: json['studentId'] as int,
      subjectId: json['subjectId'] as int,
      date: DateTime.parse(json['date'] as String),
      isPositive: json['isPositive'] as bool,
      note: json['note'] as String?,
      behaviorId: json['behaviorId'] as int?,
      sessionId: json['sessionId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'subjectId': subjectId,
      'date': date.toIso8601String(),
      'isPositive': isPositive,
      'note': note,
      'behaviorId': behaviorId,
      'sessionId': sessionId,
    };
  }
}
