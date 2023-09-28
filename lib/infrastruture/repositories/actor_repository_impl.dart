import 'package:cinema/domain/datasources/actor_datasource.dart';
import 'package:cinema/domain/entities/actor_entity.dart';
import 'package:cinema/domain/repositories/actor_repository.dart';

class ActorRepositoryImpl extends ActorRepository {
  final ActorDatasource datasource;

  ActorRepositoryImpl({required this.datasource});

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasource.getActorsByMovie(movieId);
  }
}
