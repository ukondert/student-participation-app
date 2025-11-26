import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/domain/entities/entities.dart';

void main() {
  group('Entity Serialization Tests', () {
    test('SchoolClass serialization', () {
      final schoolClass = SchoolClass(
        id: 1,
        name: '10A',
        teacher: 'Mr. Smith',
        room: '101',
        schoolYear: '2023/2024',
      );

      final json = schoolClass.toJson();
      expect(json['id'], 1);
      expect(json['name'], '10A');

      final fromJson = SchoolClass.fromJson(json);
      expect(fromJson.id, schoolClass.id);
      expect(fromJson.name, schoolClass.name);
    });

    test('Subject serialization', () {
      final subject = Subject(
        id: 1,
        name: 'Mathematics',
        shortName: 'Math',
        classId: 1,
        notes: 'Algebra',
      );

      final json = subject.toJson();
      expect(json['id'], 1);
      expect(json['name'], 'Mathematics');

      final fromJson = Subject.fromJson(json);
      expect(fromJson.id, subject.id);
      expect(fromJson.name, subject.name);
    });

    test('Student serialization', () {
      final student = Student(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
        shortCode: 'JD',
        classId: 1,
        photoPath: '/path/to/photo.jpg',
      );

      final json = student.toJson();
      expect(json['id'], 1);
      expect(json['firstName'], 'John');

      final fromJson = Student.fromJson(json);
      expect(fromJson.id, student.id);
      expect(fromJson.firstName, student.firstName);
    });

    test('NegativeBehavior serialization', () {
      final behavior = NegativeBehavior(
        id: 1,
        description: 'Disruptive',
      );

      final json = behavior.toJson();
      expect(json['id'], 1);
      expect(json['description'], 'Disruptive');

      final fromJson = NegativeBehavior.fromJson(json);
      expect(fromJson.id, behavior.id);
      expect(fromJson.description, behavior.description);
    });

    test('Participation serialization', () {
      final date = DateTime(2023, 10, 27, 10, 0, 0);
      final participation = Participation(
        id: 1,
        studentId: 1,
        subjectId: 1,
        date: date,
        isPositive: true,
        note: 'Good answer',
      );

      final json = participation.toJson();
      expect(json['id'], 1);
      expect(json['date'], date.toIso8601String());

      final fromJson = Participation.fromJson(json);
      expect(fromJson.id, participation.id);
      expect(fromJson.date, date);
    });

    test('ProtocolSession serialization', () {
      final startTime = DateTime(2023, 10, 27, 9, 0, 0);
      final endTime = DateTime(2023, 10, 27, 10, 0, 0);
      final session = ProtocolSession(
        id: 1,
        subjectId: 1,
        startTime: startTime,
        endTime: endTime,
        topic: 'Algebra',
      );

      final json = session.toJson();
      expect(json['id'], 1);
      expect(json['startTime'], startTime.toIso8601String());

      final fromJson = ProtocolSession.fromJson(json);
      expect(fromJson.id, session.id);
      expect(fromJson.startTime, startTime);
    });

    test('ParticipationWithDetails serialization', () {
      final date = DateTime(2023, 10, 27, 10, 0, 0);
      final participation = Participation(
        id: 1,
        studentId: 1,
        subjectId: 1,
        date: date,
        isPositive: false,
        behaviorId: 1,
      );
      final behavior = NegativeBehavior(id: 1, description: 'Talking');
      
      final details = ParticipationWithDetails(
        participation: participation,
        description: 'Talking',
        behavior: behavior,
      );

      final json = details.toJson();
      expect(json['description'], 'Talking');
      expect(json['behavior']['description'], 'Talking');

      final fromJson = ParticipationWithDetails.fromJson(json);
      expect(fromJson.description, details.description);
      expect(fromJson.behavior?.description, behavior.description);
    });
  });
}
