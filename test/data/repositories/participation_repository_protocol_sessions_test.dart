import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_participation_app/data/datasources/database.dart';
import 'package:student_participation_app/data/repositories/participation_repository_impl.dart';

void main() {
  late AppDatabase database;
  late ParticipationRepositoryImpl repository;

  setUp(() async {
    // Create in-memory database for testing
    database = AppDatabase.forTestingWithConnection(NativeDatabase.memory());
    repository = ParticipationRepositoryImpl(database);

    // Insert test data
    await _insertTestData(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Protocol Session Tests', () {
    test('startSession creates a new session with current timestamp', () async {
      final subjectId = 1;
      final topic = 'Quadratische Gleichungen';
      final notes = 'Einführung in pq-Formel';
      final homework = 'Übungen S. 42';

      final sessionId = await repository.startSession(
        subjectId,
        topic: topic,
        notes: notes,
        homework: homework,
      );

      expect(sessionId, greaterThan(0));

      final session = await repository.getActiveSession(subjectId);
      expect(session, isNotNull);
      expect(session!.id, sessionId);
      expect(session.subjectId, subjectId);
      expect(session.topic, topic);
      expect(session.notes, notes);
      expect(session.homework, homework);
      expect(session.endTime, isNull);
      expect(session.startTime, isNotNull);
    });

    test('startSession creates session with minimal data', () async {
      final subjectId = 1;

      final sessionId = await repository.startSession(subjectId);

      expect(sessionId, greaterThan(0));

      final session = await repository.getActiveSession(subjectId);
      expect(session, isNotNull);
      expect(session!.topic, isNull);
      expect(session.notes, isNull);
      expect(session.homework, isNull);
    });

    test('getActiveSession returns null when no active session exists', () async {
      final session = await repository.getActiveSession(999);
      expect(session, isNull);
    });

    test('getActiveSession returns only active (not ended) session', () async {
      final subjectId = 1;

      // Start and end first session
      final sessionId1 = await repository.startSession(subjectId, topic: 'Session 1');
      await repository.endSession(sessionId1);

      // Start second session (active)
      final sessionId2 = await repository.startSession(subjectId, topic: 'Session 2');

      final activeSession = await repository.getActiveSession(subjectId);
      expect(activeSession, isNotNull);
      expect(activeSession!.id, sessionId2);
      expect(activeSession.topic, 'Session 2');
      expect(activeSession.endTime, isNull);
    });

    test('endSession sets endTime to current timestamp', () async {
      final subjectId = 1;
      final sessionId = await repository.startSession(subjectId);

      // Wait a moment to ensure different timestamps
      await Future.delayed(const Duration(milliseconds: 10));

      await repository.endSession(sessionId);

      final session = await repository.getActiveSession(subjectId);
      expect(session, isNull); // Should not be active anymore

      final allSessions = await repository.getSessionsForSubject(subjectId);
      final endedSession = allSessions.firstWhere((s) => s.id == sessionId);
      expect(endedSession.endTime, isNotNull);
      expect(endedSession.endTime!.isAfter(endedSession.startTime), isTrue);
    });

    test('updateSession modifies session metadata', () async {
      final subjectId = 1;
      final sessionId = await repository.startSession(
        subjectId,
        topic: 'Original Topic',
      );

      await repository.updateSession(
        sessionId,
        topic: 'Updated Topic',
        notes: 'New Notes',
        homework: 'New Homework',
      );

      final session = await repository.getActiveSession(subjectId);
      expect(session, isNotNull);
      expect(session!.topic, 'Updated Topic');
      expect(session.notes, 'New Notes');
      expect(session.homework, 'New Homework');
    });

    test('updateSession with partial data only updates specified fields', () async {
      final subjectId = 1;
      final sessionId = await repository.startSession(
        subjectId,
        topic: 'Original Topic',
        notes: 'Original Notes',
      );

      await repository.updateSession(
        sessionId,
        topic: 'Updated Topic',
      );

      final session = await repository.getActiveSession(subjectId);
      expect(session, isNotNull);
      expect(session!.topic, 'Updated Topic');
      expect(session.notes, 'Original Notes'); // Should remain unchanged
    });

    test('getSessionsForSubject returns all sessions for subject', () async {
      final subjectId = 1;

      final sessionId1 = await repository.startSession(subjectId, topic: 'Session 1');
      await repository.endSession(sessionId1);

      final sessionId2 = await repository.startSession(subjectId, topic: 'Session 2');

      final sessions = await repository.getSessionsForSubject(subjectId);
      expect(sessions.length, 2);
      expect(sessions.any((s) => s.id == sessionId1), isTrue);
      expect(sessions.any((s) => s.id == sessionId2), isTrue);
    });

    test('getSessionsForSubject returns sessions ordered by start time descending', () async {
      final subjectId = 1;

      await Future.delayed(const Duration(milliseconds: 10));
      final sessionId1 = await repository.startSession(subjectId, topic: 'First');

      await Future.delayed(const Duration(milliseconds: 10));
      final sessionId2 = await repository.startSession(subjectId, topic: 'Second');

      await Future.delayed(const Duration(milliseconds: 10));
      final sessionId3 = await repository.startSession(subjectId, topic: 'Third');

      final sessions = await repository.getSessionsForSubject(subjectId);
      expect(sessions.length, 3);
      expect(sessions[0].id, sessionId3); // Most recent first
      expect(sessions[1].id, sessionId2);
      expect(sessions[2].id, sessionId1);
    });

    test('watchActiveSession stream emits updates', () async {
      final subjectId = 1;

      final stream = repository.watchActiveSession(subjectId);

      // Initially no session
      expect(await stream.first, isNull);

      // Start a session
      final sessionId = await repository.startSession(subjectId, topic: 'Test');

      // Stream should emit the new session
      final session = await stream.first;
      expect(session, isNotNull);
      expect(session!.id, sessionId);
    });

    test('addParticipation can link to active session', () async {
      final subjectId = 1;
      final studentId = 1;

      final sessionId = await repository.startSession(subjectId);

      final participationId = await repository.addParticipation(
        studentId,
        subjectId,
        true,
        sessionId: sessionId,
      );

      expect(participationId, greaterThan(0));

      // Verify the participation has the session linked
      final participations = await repository.getParticipationsForSubject(subjectId);
      final participation = participations.firstWhere((p) => p.id == participationId);
      expect(participation.sessionId, sessionId);
    });

    test('multiple subjects can have independent active sessions', () async {
      final subject1Id = 1;
      final subject2Id = 2;

      final session1Id = await repository.startSession(subject1Id, topic: 'Math');
      final session2Id = await repository.startSession(subject2Id, topic: 'Physics');

      final session1 = await repository.getActiveSession(subject1Id);
      final session2 = await repository.getActiveSession(subject2Id);

      expect(session1, isNotNull);
      expect(session2, isNotNull);
      expect(session1!.id, session1Id);
      expect(session2!.id, session2Id);
      expect(session1.topic, 'Math');
      expect(session2.topic, 'Physics');
    });
  });
}

/// Helper function to insert test data
Future<void> _insertTestData(AppDatabase db) async {
  // Insert a test class
  await db.into(db.classes).insert(ClassesCompanion.insert(
    name: 'Test Class 5A',
  ));

  // Insert test subjects
  await db.into(db.subjects).insert(SubjectsCompanion.insert(
    name: 'Mathematik',
    shortName: 'M',
    classId: 1,
  ));

  await db.into(db.subjects).insert(SubjectsCompanion.insert(
    name: 'Physik',
    shortName: 'PH',
    classId: 1,
  ));

  // Insert a test student
  await db.into(db.students).insert(StudentsCompanion.insert(
    firstName: 'Max',
    lastName: 'Mustermann',
    shortCode: 'MM',
    classId: 1,
  ));
}
