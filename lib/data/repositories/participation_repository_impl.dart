import 'package:drift/drift.dart';
import '../../domain/entities/entities.dart' as domain;
import '../../domain/repositories/i_participation_repository.dart';
import '../datasources/database.dart' as db;

class ParticipationRepositoryImpl implements IParticipationRepository {
  final db.AppDatabase _db;

  ParticipationRepositoryImpl(this._db);

  // Participation
  @override
  Stream<List<domain.Participation>> watchParticipations(
      int studentId, int subjectId) {
    return (_db.select(_db.participations)
          ..where((tbl) =>
              tbl.studentId.equals(studentId) & tbl.subjectId.equals(subjectId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .watch()
        .map((rows) {
      return rows
          .map((row) => domain.Participation(
                id: row.id,
                studentId: row.studentId,
                subjectId: row.subjectId,
                date: row.date,
                isPositive: row.isPositive,
                note: row.note,
                behaviorId: row.behaviorId,
                sessionId: row.sessionId,
              ))
          .toList();
    });
  }

  @override
  Future<List<domain.Participation>> getParticipationsForSubject(
      int subjectId) async {
    final rows = await (_db.select(_db.participations)
          ..where((tbl) => tbl.subjectId.equals(subjectId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)
          ]))
        .get();

    return rows
        .map((row) => domain.Participation(
              id: row.id,
              studentId: row.studentId,
              subjectId: row.subjectId,
              date: row.date,
              isPositive: row.isPositive,
              note: row.note,
              behaviorId: row.behaviorId,
              sessionId: row.sessionId,
            ))
        .toList();
  }

  @override
  Future<List<domain.Participation>> getParticipationsForStudent(
      int studentId) async {
    final rows = await (_db.select(_db.participations)
          ..where((tbl) => tbl.studentId.equals(studentId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .get();

    return rows
        .map((row) => domain.Participation(
              id: row.id,
              studentId: row.studentId,
              subjectId: row.subjectId,
              date: row.date,
              isPositive: row.isPositive,
              note: row.note,
              behaviorId: row.behaviorId,
              sessionId: row.sessionId,
            ))
        .toList();
  }

  @override
  Future<List<domain.Participation>> getAllParticipations() async {
    final rows = await _db.select(_db.participations).get();

    return rows
        .map((row) => domain.Participation(
              id: row.id,
              studentId: row.studentId,
              subjectId: row.subjectId,
              date: row.date,
              isPositive: row.isPositive,
              note: row.note,
              behaviorId: row.behaviorId,
              sessionId: row.sessionId,
            ))
        .toList();
  }

  @override
  Future<List<domain.ParticipationWithDetails>>
      getParticipationsWithDetailsForStudent(int studentId) async {
    // 1. Load participations for the student
    final participations = await getParticipationsForStudent(studentId);

    if (participations.isEmpty) {
      return [];
    }

    // 2. Load all negative behaviors
    final behaviors = await watchNegativeBehaviors().first;
    final behaviorMap = {for (var b in behaviors) b.id: b};

    // 3. Load all sessions for the subjects involved
    final subjectIds = participations.map((p) => p.subjectId).toSet();
    final sessionMap = await _loadSessionsForSubjects(subjectIds);

    // 4. Combine everything into ParticipationWithDetails
    return participations.map((p) {
      final session = p.sessionId != null ? sessionMap[p.sessionId] : null;
      final behavior = p.behaviorId != null ? behaviorMap[p.behaviorId] : null;

      final description = p.isPositive
          ? 'Positive Mitarbeit'
          : (behavior?.description ?? p.note ?? 'Negativ');

      return domain.ParticipationWithDetails(
        participation: p,
        description: description,
        session: session,
        behavior: behavior,
      );
    }).toList();
  }

  Future<Map<int, domain.ProtocolSession>> _loadSessionsForSubjects(
      Set<int> subjectIds) async {
    if (subjectIds.isEmpty) return {};

    final Map<int, domain.ProtocolSession> sessionMap = {};

    for (final subjectId in subjectIds) {
      final sessions = await getSessionsForSubject(subjectId);
      for (final session in sessions) {
        sessionMap[session.id] = session;
      }
    }

    return sessionMap;
  }

  @override
  Future<int> addParticipation(int studentId, int subjectId, bool isPositive,
      {String? note, int? behaviorId, int? sessionId}) {
    return _db
        .into(_db.participations)
        .insert(db.ParticipationsCompanion.insert(
          studentId: studentId,
          subjectId: subjectId,
          date: DateTime.now(),
          isPositive: isPositive,
          note: Value(note),
          behaviorId: Value(behaviorId),
          sessionId: Value(sessionId),
        ));
  }

  @override
  Future<void> deleteParticipation(int id) {
    return (_db.delete(_db.participations)..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  // Negative Behaviors
  @override
  Stream<List<domain.NegativeBehavior>> watchNegativeBehaviors() {
    return _db.select(_db.negativeBehaviors).watch().map((rows) {
      return rows
          .map((row) => domain.NegativeBehavior(
                id: row.id,
                description: row.description,
              ))
          .toList();
    });
  }

  @override
  Future<int> addNegativeBehavior(String description) {
    return _db
        .into(_db.negativeBehaviors)
        .insert(db.NegativeBehaviorsCompanion.insert(
          description: description,
        ));
  }

  @override
  Future<void> deleteNegativeBehavior(int id) {
    return (_db.delete(_db.negativeBehaviors)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  // Protocol Sessions
  @override
  Future<int> startSession(int subjectId,
      {String? topic, String? notes, String? homework}) {
    return _db
        .into(_db.protocolSessions)
        .insert(db.ProtocolSessionsCompanion.insert(
          subjectId: subjectId,
          startTime: DateTime.now(),
          topic: Value(topic),
          notes: Value(notes),
          homework: Value(homework),
        ));
  }

  @override
  Future<void> endSession(int sessionId) async {
    await (_db.update(_db.protocolSessions)
          ..where((tbl) => tbl.id.equals(sessionId)))
        .write(
      db.ProtocolSessionsCompanion(
        endTime: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> updateSession(int sessionId,
      {String? topic, String? notes, String? homework}) async {
    await (_db.update(_db.protocolSessions)
          ..where((tbl) => tbl.id.equals(sessionId)))
        .write(
      db.ProtocolSessionsCompanion(
        topic: Value(topic),
        notes: Value(notes),
        homework: Value(homework),
      ),
    );
  }

  @override
  Future<domain.ProtocolSession?> getActiveSession(int subjectId) async {
    final row = await (_db.select(_db.protocolSessions)
          ..where(
              (tbl) => tbl.subjectId.equals(subjectId) & tbl.endTime.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.startTime, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingleOrNull();

    if (row == null) return null;

    return domain.ProtocolSession(
      id: row.id,
      subjectId: row.subjectId,
      startTime: row.startTime,
      endTime: row.endTime,
      topic: row.topic,
      notes: row.notes,
      homework: row.homework,
    );
  }

  @override
  Stream<domain.ProtocolSession?> watchActiveSession(int subjectId) {
    return (_db.select(_db.protocolSessions)
          ..where(
              (tbl) => tbl.subjectId.equals(subjectId) & tbl.endTime.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.startTime, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .watchSingleOrNull()
        .map((row) {
      if (row == null) return null;
      return domain.ProtocolSession(
        id: row.id,
        subjectId: row.subjectId,
        startTime: row.startTime,
        endTime: row.endTime,
        topic: row.topic,
        notes: row.notes,
        homework: row.homework,
      );
    });
  }

  @override
  Future<List<domain.ProtocolSession>> getSessionsForSubject(
      int subjectId) async {
    final rows = await (_db.select(_db.protocolSessions)
          ..where((tbl) => tbl.subjectId.equals(subjectId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.startTime, mode: OrderingMode.desc)
          ]))
        .get();

    return rows
        .map((row) => domain.ProtocolSession(
              id: row.id,
              subjectId: row.subjectId,
              startTime: row.startTime,
              endTime: row.endTime,
              topic: row.topic,
              notes: row.notes,
              homework: row.homework,
            ))
        .toList();
  }
}
