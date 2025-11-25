import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/domain/repositories/i_participation_repository.dart';

class MockParticipationRepository implements IParticipationRepository {
  // Exposable streams for tests
  Stream<List<Participation>> participationsStream = const Stream.empty();
  Stream<ProtocolSession?> activeSessionStream = const Stream.empty();
  final List<int> deletedParticipationIds = [];
  @override
  Future<List<Participation>> getParticipationsForStudent(int studentId) async => [];

  @override
  Future<List<Participation>> getParticipationsForSubject(int subjectId) async => [];

  @override
  Future<List<Participation>> getAllParticipations() async => [];

  @override
  Future<List<ParticipationWithDetails>> getParticipationsWithDetailsForStudent(int studentId) async => [];

  @override
  Future<int> addParticipation(int studentId, int subjectId, bool isPositive, {String? note, int? behaviorId, int? sessionId}) async => 1;

  @override
  Future<void> deleteParticipation(int id) async {
    deletedParticipationIds.add(id);
  }

  @override
  Stream<List<Participation>> watchParticipations(int studentId, int subjectId) => participationsStream;

  @override
  Stream<List<NegativeBehavior>> watchNegativeBehaviors() => const Stream.empty();

  @override
  Future<int> addNegativeBehavior(String description) async => 1;

  @override
  Future<void> deleteNegativeBehavior(int id) async {}

  // Protocol session methods (stubbed for tests)
  @override
  Future<int> startSession(int subjectId, {String? topic, String? notes, String? homework}) async => 1;

  @override
  Future<void> endSession(int sessionId) async {}

  @override
  Future<void> updateSession(int sessionId, {String? topic, String? notes, String? homework}) async {}

  @override
  Future<ProtocolSession?> getActiveSession(int subjectId) async => null;

  @override
  Stream<ProtocolSession?> watchActiveSession(int subjectId) => activeSessionStream;

  @override
  Future<List<ProtocolSession>> getSessionsForSubject(int subjectId) async => [];
}
