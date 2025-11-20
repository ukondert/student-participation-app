import 'package:drift/drift.dart';
import '../../domain/entities/entities.dart' as domain;
import '../../domain/repositories/i_participation_repository.dart';
import '../datasources/database.dart' as db;

class ParticipationRepositoryImpl implements IParticipationRepository {
  final db.AppDatabase _db;

  ParticipationRepositoryImpl(this._db);

  // Participation
  @override
  Stream<List<domain.Participation>> watchParticipations(int studentId, int subjectId) {
    return (_db.select(_db.participations)
          ..where((tbl) => tbl.studentId.equals(studentId) & tbl.subjectId.equals(subjectId))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) {
      return rows.map((row) => domain.Participation(
        id: row.id,
        studentId: row.studentId,
        subjectId: row.subjectId,
        date: row.date,
        isPositive: row.isPositive,
        note: row.note,
        behaviorId: row.behaviorId,
      )).toList();
    });
  }

  @override
  Future<List<domain.Participation>> getParticipationsForSubject(int subjectId) async {
    final rows = await (_db.select(_db.participations)
          ..where((tbl) => tbl.subjectId.equals(subjectId))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)]))
        .get();
    
    return rows.map((row) => domain.Participation(
        id: row.id,
        studentId: row.studentId,
        subjectId: row.subjectId,
        date: row.date,
        isPositive: row.isPositive,
        note: row.note,
        behaviorId: row.behaviorId,
      )).toList();
  }

  @override
  Future<List<domain.Participation>> getParticipationsForStudent(int studentId) async {
    final rows = await (_db.select(_db.participations)
          ..where((tbl) => tbl.studentId.equals(studentId))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .get();
    
    return rows.map((row) => domain.Participation(
        id: row.id,
        studentId: row.studentId,
        subjectId: row.subjectId,
        date: row.date,
        isPositive: row.isPositive,
        note: row.note,
        behaviorId: row.behaviorId,
      )).toList();
  }

  @override
  Future<int> addParticipation(int studentId, int subjectId, bool isPositive, {String? note, int? behaviorId}) {
    return _db.into(_db.participations).insert(db.ParticipationsCompanion.insert(
      studentId: studentId,
      subjectId: subjectId,
      date: DateTime.now(),
      isPositive: isPositive,
      note: Value(note),
      behaviorId: Value(behaviorId),
    ));
  }

  @override
  Future<void> deleteParticipation(int id) {
    return (_db.delete(_db.participations)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Negative Behaviors
  @override
  Stream<List<domain.NegativeBehavior>> watchNegativeBehaviors() {
    return _db.select(_db.negativeBehaviors).watch().map((rows) {
      return rows.map((row) => domain.NegativeBehavior(
        id: row.id,
        description: row.description,
      )).toList();
    });
  }

  @override
  Future<int> addNegativeBehavior(String description) {
    return _db.into(_db.negativeBehaviors).insert(db.NegativeBehaviorsCompanion.insert(
      description: description,
    ));
  }

  @override
  Future<void> deleteNegativeBehavior(int id) {
    return (_db.delete(_db.negativeBehaviors)..where((tbl) => tbl.id.equals(id))).go();
  }
}
