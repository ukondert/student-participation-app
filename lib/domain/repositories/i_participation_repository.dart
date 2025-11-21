import '../entities/entities.dart';

abstract class IParticipationRepository {
  // Participation
  Stream<List<Participation>> watchParticipations(int studentId, int subjectId);
  Future<List<Participation>> getParticipationsForSubject(int subjectId);
  Future<List<Participation>> getParticipationsForStudent(int studentId);
  Future<List<Participation>> getAllParticipations();
  Future<int> addParticipation(int studentId, int subjectId, bool isPositive, {String? note, int? behaviorId});
  Future<void> deleteParticipation(int id);

  // Negative Behaviors
  Stream<List<NegativeBehavior>> watchNegativeBehaviors();
  Future<int> addNegativeBehavior(String description);
  Future<void> deleteNegativeBehavior(int id);
}
