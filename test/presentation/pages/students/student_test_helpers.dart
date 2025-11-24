import 'package:student_participation_app/domain/entities/entities.dart';
import 'package:student_participation_app/domain/repositories/i_participation_repository.dart';

class MockParticipationRepository implements IParticipationRepository {
  @override
  Future<List<Participation>> getParticipationsForStudent(int studentId) async => [];

  @override
  Future<List<Participation>> getParticipationsForSubject(int subjectId) async => [];

  @override
  Future<List<Participation>> getAllParticipations() async => [];

  @override
  Future<int> addParticipation(int studentId, int subjectId, bool isPositive, {String? note, int? behaviorId}) async => 1;

  @override
  Future<void> deleteParticipation(int id) async {}

  @override
  Stream<List<Participation>> watchParticipations(int studentId, int subjectId) => const Stream.empty();

  @override
  Stream<List<NegativeBehavior>> watchNegativeBehaviors() => const Stream.empty();

  @override
  Future<int> addNegativeBehavior(String description) async => 1;

  @override
  Future<void> deleteNegativeBehavior(int id) async {}
}
