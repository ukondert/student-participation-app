import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_participation_app/data/services/data_import_service.dart';
import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/domain/repositories/i_class_repository.dart';
import 'package:student_participation_app/domain/repositories/i_participation_repository.dart';

import 'data_import_service_test.mocks.dart';

@GenerateMocks([IClassRepository, IParticipationRepository])
void main() {
  group('DataImportService', () {
    late MockIClassRepository classRepo;
    late MockIParticipationRepository participationRepo;
    late DataImportService importService;

    setUp(() {
      classRepo = MockIClassRepository();
      participationRepo = MockIParticipationRepository();
      importService = DataImportService(classRepo, participationRepo);
    });

    test('does not duplicate existing classes, subjects, students', () async {
      // Existing data
      final existingClass = SchoolClass(id: 1, name: 'Class A', teacher: null, room: null, schoolYear: null);
      final existingSubject = Subject(id: 10, name: 'Math', shortName: 'M', notes: null, classId: 1);
      final existingStudent = Student(id: 100, firstName: 'John', lastName: 'Doe', photoPath: null, shortCode: 'JD', classId: 1);

      when(classRepo.getAllClasses()).thenAnswer((_) async => [existingClass]);
      when(classRepo.getAllSubjects()).thenAnswer((_) async => [existingSubject]);
      when(classRepo.getAllStudents()).thenAnswer((_) async => [existingStudent]);

      // Mock add methods to return new IDs
      when(classRepo.addClass(any, any, any, any))
          .thenAnswer((_) async => 2);
      when(classRepo.addSubject(any, any, any, any))
          .thenAnswer((_) async => 20);
      when(classRepo.addStudent(any, any, any, any, any))
          .thenAnswer((_) async => 200);

      // JSON with duplicate class, subject, student and a new one
      final jsonString = jsonEncode({
        'classes': [
          {'id': 1, 'name': 'Class A', 'teacher': null, 'room': null, 'schoolYear': null},
          {'id': 2, 'name': 'Class B', 'teacher': 'Ms. Smith', 'room': '101', 'schoolYear': '2025'}
        ],
        'subjects': [
          {'id': 10, 'name': 'Math', 'shortName': 'M', 'notes': null, 'classId': 1},
          {'id': 20, 'name': 'Science', 'shortName': 'S', 'notes': null, 'classId': 2}
        ],
        'students': [
          {'id': 100, 'firstName': 'John', 'lastName': 'Doe', 'photoPath': null, 'shortCode': 'JD', 'classId': 1},
          {'id': 200, 'firstName': 'Jane', 'lastName': 'Roe', 'photoPath': null, 'shortCode': 'JR', 'classId': 2}
        ]
      });

      await importService.importData(jsonString);

      // Verify that addClass was called only for the new class
      verify(classRepo.addClass('Class B', 'Ms. Smith', '101', '2025')).called(1);
      verifyNever(classRepo.addClass('Class A', null, null, null));

      // Verify that addSubject was called only for the new subject
      verify(classRepo.addSubject('Science', 'S', null, 2)).called(1);
      verifyNever(classRepo.addSubject('Math', 'M', null, 1));

      // Verify that addStudent was called only for the new student
      verify(classRepo.addStudent('Jane', 'Roe', null, 'JR', 2)).called(1);
      verifyNever(classRepo.addStudent('John', 'Doe', null, 'JD', 1));
    });
  });
}
