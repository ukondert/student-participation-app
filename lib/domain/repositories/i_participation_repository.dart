import '../entities/entities.dart';

abstract class IParticipationRepository {
  // Participation
  Stream<List<Participation>> watchParticipations(int studentId, int subjectId);
  Future<List<Participation>> getParticipationsForSubject(int subjectId);
  Future<List<Participation>> getParticipationsForStudent(int studentId);
  Future<List<Participation>> getAllParticipations();
  Future<List<ParticipationWithDetails>> getParticipationsWithDetailsForStudent(
      int studentId);
  Future<int> addParticipation(int studentId, int subjectId, bool isPositive,
      {String? note, int? behaviorId, int? sessionId});
  Future<void> deleteParticipation(int id);

  // Negative Behaviors
  Stream<List<NegativeBehavior>> watchNegativeBehaviors();
  Future<int> addNegativeBehavior(String description);
  Future<void> deleteNegativeBehavior(int id);

  // Protocol Sessions
  Future<int> startSession(int subjectId,
      {String? topic, String? notes, String? homework});
  Future<int> addSession(
      int subjectId,
      DateTime startTime,
      DateTime? endTime, {
      String? topic,
      String? notes,
      String? homework,
  });
  Future<void> endSession(int sessionId);
  Future<void> updateSession(int sessionId,
      {String? topic, String? notes, String? homework});
  Future<ProtocolSession?> getActiveSession(int subjectId);
  Stream<ProtocolSession?> watchActiveSession(int subjectId);
  Future<List<ProtocolSession>> getSessionsForSubject(int subjectId);
  Future<List<ProtocolSession>> getAllSessions();
}
