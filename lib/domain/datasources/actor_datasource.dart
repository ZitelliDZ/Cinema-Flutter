import 'package:cinema/domain/entities/actor_entity.dart';

abstract class ActorDatasource {
  Future<List<Actor>> getActorsByMovie(String movieId);
}
