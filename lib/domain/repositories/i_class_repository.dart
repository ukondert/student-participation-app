import '../entities/entities.dart';

abstract class IClassRepository {
  // Classes
  Stream<List<SchoolClass>> watchClasses();
  Stream<List<Subject>> watchAllSubjects();
  Future<int> addClass(String name, String? teacher, String? room, String? schoolYear);
  Future<void> updateClass(SchoolClass schoolClass);
  Future<void> deleteClass(int id);

  // Subjects
  Stream<List<Subject>> watchSubjects(int classId);
  Future<int> addSubject(String name, String shortName, String? notes, int classId);
  Future<void> updateSubject(Subject subject);
  Future<void> deleteSubject(int id);

  // Students
  Stream<List<Student>> watchStudents(int classId);
  Future<int> addStudent(String firstName, String lastName, String? photoPath, String shortCode, int classId);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(int id);
}

// Extended Subject class with class name
class SubjectWithClass {
  final Subject subject;
  final String className;
  
  SubjectWithClass({required this.subject, required this.className});
}
