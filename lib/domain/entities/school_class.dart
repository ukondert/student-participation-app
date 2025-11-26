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

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return SchoolClass(
      id: json['id'] as int,
      name: json['name'] as String,
      teacher: json['teacher'] as String?,
      room: json['room'] as String?,
      schoolYear: json['schoolYear'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teacher': teacher,
      'room': room,
      'schoolYear': schoolYear,
    };
  }
}
