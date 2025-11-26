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

  factory ProtocolSession.fromJson(Map<String, dynamic> json) {
    return ProtocolSession(
      id: json['id'] as int,
      subjectId: json['subjectId'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      topic: json['topic'] as String?,
      notes: json['notes'] as String?,
      homework: json['homework'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'topic': topic,
      'notes': notes,
      'homework': homework,
    };
  }
}
