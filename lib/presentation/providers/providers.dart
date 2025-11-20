import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/database.dart';
import '../../data/repositories/class_repository_impl.dart';
import '../../data/repositories/participation_repository_impl.dart';
import '../../domain/repositories/i_class_repository.dart';
import '../../domain/repositories/i_participation_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

@Riverpod(keepAlive: true)
IClassRepository classRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ClassRepositoryImpl(db);
}

@Riverpod(keepAlive: true)
IParticipationRepository participationRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ParticipationRepositoryImpl(db);
}
