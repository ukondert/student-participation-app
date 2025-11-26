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

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as int,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      notes: json['notes'] as String?,
      classId: json['classId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'notes': notes,
      'classId': classId,
    };
  }
}
