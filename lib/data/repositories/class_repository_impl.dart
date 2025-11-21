import 'package:drift/drift.dart';
import '../../domain/entities/entities.dart' as domain;
import '../../domain/repositories/i_class_repository.dart';
import '../datasources/database.dart' as db;

class ClassRepositoryImpl implements IClassRepository {
  final db.AppDatabase _db;

  ClassRepositoryImpl(this._db);

  // Classes
  @override
  Stream<List<domain.SchoolClass>> watchClasses() {
    return _db.select(_db.classes).watch().map((rows) {
      return rows.map((row) => domain.SchoolClass(
        id: row.id,
        name: row.name,
        teacher: row.teacher,
        room: row.room,
        schoolYear: row.schoolYear,
      )).toList();
    });
  }

  @override
  Stream<List<domain.Subject>> watchAllSubjects() {
    return _db.select(_db.subjects).watch().map((rows) {
      return rows.map((row) => domain.Subject(
        id: row.id,
        name: row.name,
        shortName: row.shortName,
        notes: row.notes,
        classId: row.classId,
      )).toList();
    });
  }

  @override
  Future<int> addClass(String name, String? teacher, String? room, String? schoolYear) {
    return _db.into(_db.classes).insert(db.ClassesCompanion.insert(
      name: name,
      teacher: Value(teacher),
      room: Value(room),
      schoolYear: Value(schoolYear),
    ));
  }

  @override
  Future<void> updateClass(domain.SchoolClass schoolClass) {
    return _db.update(_db.classes).replace(db.ClassesCompanion(
      id: Value(schoolClass.id),
      name: Value(schoolClass.name),
      teacher: Value(schoolClass.teacher),
      room: Value(schoolClass.room),
      schoolYear: Value(schoolClass.schoolYear),
    ));
  }

  @override
  Future<void> deleteClass(int id) {
    return (_db.delete(_db.classes)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Subjects
  @override
  Stream<List<domain.Subject>> watchSubjects(int classId) {
    return (_db.select(_db.subjects)..where((tbl) => tbl.classId.equals(classId))).watch().map((rows) {
      return rows.map((row) => domain.Subject(
        id: row.id,
        name: row.name,
        shortName: row.shortName,
        notes: row.notes,
        classId: row.classId,
      )).toList();
    });
  }

  @override
  Future<int> addSubject(String name, String shortName, String? notes, int classId) {
    return _db.into(_db.subjects).insert(db.SubjectsCompanion.insert(
      name: name,
      shortName: shortName,
      notes: Value(notes),
      classId: classId,
    ));
  }

  @override
  Future<void> updateSubject(domain.Subject subject) {
    return _db.update(_db.subjects).replace(db.SubjectsCompanion(
      id: Value(subject.id),
      name: Value(subject.name),
      shortName: Value(subject.shortName),
      notes: Value(subject.notes),
      classId: Value(subject.classId),
    ));
  }

  @override
  Future<void> deleteSubject(int id) {
    return (_db.delete(_db.subjects)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Students
  @override
  Stream<List<domain.Student>> watchStudents(int classId) {
    return (_db.select(_db.students)..where((tbl) => tbl.classId.equals(classId))).watch().map((rows) {
      return rows.map((row) => domain.Student(
        id: row.id,
        firstName: row.firstName,
        lastName: row.lastName,
        photoPath: row.photoPath,
        shortCode: row.shortCode,
        classId: row.classId,
      )).toList();
    });
  }

  @override
  Future<int> addStudent(String firstName, String lastName, String? photoPath, String shortCode, int classId) {
    return _db.into(_db.students).insert(db.StudentsCompanion.insert(
      firstName: firstName,
      lastName: lastName,
      photoPath: Value(photoPath),
      shortCode: shortCode,
      classId: classId,
    ));
  }

  @override
  Future<void> updateStudent(domain.Student student) {
    return _db.update(_db.students).replace(db.StudentsCompanion(
      id: Value(student.id),
      firstName: Value(student.firstName),
      lastName: Value(student.lastName),
      photoPath: Value(student.photoPath),
      shortCode: Value(student.shortCode),
      classId: Value(student.classId),
    ));
  }

  @override
  Future<void> deleteStudent(int id) {
    return (_db.delete(_db.students)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Export/Import
  @override
  Future<List<domain.SchoolClass>> getAllClasses() {
    return _db.select(_db.classes).get().then((rows) {
      return rows.map((row) => domain.SchoolClass(
        id: row.id,
        name: row.name,
        teacher: row.teacher,
        room: row.room,
        schoolYear: row.schoolYear,
      )).toList();
    });
  }

  @override
  Future<List<domain.Subject>> getAllSubjects() {
    return _db.select(_db.subjects).get().then((rows) {
      return rows.map((row) => domain.Subject(
        id: row.id,
        name: row.name,
        shortName: row.shortName,
        notes: row.notes,
        classId: row.classId,
      )).toList();
    });
  }

  @override
  Future<List<domain.Student>> getAllStudents() {
    return _db.select(_db.students).get().then((rows) {
      return rows.map((row) => domain.Student(
        id: row.id,
        firstName: row.firstName,
        lastName: row.lastName,
        photoPath: row.photoPath,
        shortCode: row.shortCode,
        classId: row.classId,
      )).toList();
    });
  }
}
