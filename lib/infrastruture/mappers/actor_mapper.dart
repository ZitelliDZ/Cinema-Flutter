import 'package:cinema/domain/entities/actor_entity.dart';
import 'package:cinema/infrastruture/models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
        id: cast.id,
        name: cast.name,
        profilePath: (cast.profilePath != null && cast.profilePath != ''  && cast.profilePath != 'null')
            ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
            : 'assets/loaders/no-actor.jpg',
        character: cast.character,
      );
}
