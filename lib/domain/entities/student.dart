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

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      photoPath: json['photoPath'] as String?,
      shortCode: json['shortCode'] as String,
      classId: json['classId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'photoPath': photoPath,
      'shortCode': shortCode,
      'classId': classId,
    };
  }
}
