import 'dart:async';

import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/domain/repositories/i_class_repository.dart';

class MockClassRepository implements IClassRepository {
  final StreamController<List<SchoolClass>> _classesController =
      StreamController<List<SchoolClass>>.broadcast();
  final StreamController<List<Subject>> _subjectsController =
      StreamController<List<Subject>>.broadcast();
  final StreamController<List<Student>> _studentsController =
      StreamController<List<Student>>.broadcast();

  int addClassCallCount = 0;
  int updateClassCallCount = 0;
  int addSubjectCallCount = 0;
  int updateSubjectCallCount = 0;
  int deleteSubjectCallCount = 0;
  int addStudentCallCount = 0;
  int updateStudentCallCount = 0;
  int deleteStudentCallCount = 0;

  SchoolClass? lastUpdatedClass;
  String? lastAddedName;
  Subject? lastUpdatedSubject;
  String? lastAddedSubjectName;
  int? lastDeletedSubjectId;
  Student? lastUpdatedStudent;
  String? lastAddedStudentFirstName;
  int? lastDeletedStudentId;

  @override
  Stream<List<SchoolClass>> watchClasses() => _classesController.stream;

  @override
  Stream<List<Subject>> watchSubjects(int classId) => _subjectsController.stream;

  @override
  Stream<List<Student>> watchStudents(int classId) => _studentsController.stream;

  void emitClasses(List<SchoolClass> classes) {
    _classesController.add(classes);
  }

  void emitSubjects(List<Subject> subjects) {
    _subjectsController.add(subjects);
  }

  void emitStudents(List<Student> students) {
    _studentsController.add(students);
  }

  void emitError(Object error) {
    _classesController.addError(error);
  }

  void emitSubjectsError(Object error) {
    _subjectsController.addError(error);
  }

  void emitStudentsError(Object error) {
    _studentsController.addError(error);
  }

  @override
  Future<void> deleteClass(int id) async {}

  @override
  Future<int> addClass(String name, String? teacher, String? room, String? schoolYear) async {
    addClassCallCount++;
    lastAddedName = name;
    return 1;
  }

  @override
  Future<void> updateClass(SchoolClass schoolClass) async {
    updateClassCallCount++;
    lastUpdatedClass = schoolClass;
  }

  @override
  Future<int> addSubject(String name, String shortName, String? notes, int classId) async {
    addSubjectCallCount++;
    lastAddedSubjectName = name;
    return 1;
  }

  @override
  Future<void> updateSubject(Subject subject) async {
    updateSubjectCallCount++;
    lastUpdatedSubject = subject;
  }

  @override
  Future<void> deleteSubject(int id) async {
    deleteSubjectCallCount++;
    lastDeletedSubjectId = id;
  }

  @override
  Future<int> addStudent(String firstName, String lastName, String? photoPath, String shortCode, int classId) async {
    addStudentCallCount++;
    lastAddedStudentFirstName = firstName;
    return 1;
  }

  @override
  Future<void> updateStudent(Student student) async {
    updateStudentCallCount++;
    lastUpdatedStudent = student;
  }

  @override
  Future<void> deleteStudent(int id) async {
    deleteStudentCallCount++;
    lastDeletedStudentId = id;
  }

  // Unused methods
  @override
  Future<List<SchoolClass>> getAllClasses() async => [];
  @override
  Future<List<Student>> getAllStudents() async => [];
  @override
  Future<List<Subject>> getAllSubjects() async => [];
  @override
  Stream<List<Subject>> watchAllSubjects() => const Stream.empty();
}
