import 'package:cinema/domain/entities/actor_entity.dart';

abstract class ActorRepository {
  Future<List<Actor>> getActorsByMovie(String movieId);
}
