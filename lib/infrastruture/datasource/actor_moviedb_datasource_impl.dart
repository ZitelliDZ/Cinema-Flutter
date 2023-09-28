import 'package:cinema/domain/datasources/actor_datasource.dart';
import 'package:cinema/domain/entities/actor_entity.dart';
import 'package:cinema/infrastruture/mappers/actor_mapper.dart';
import 'package:cinema/infrastruture/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';
import 'package:cinema/config/constants/environment.dart';

class ActorMoviedbDatasourceImpl extends ActorDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Enviroment.movieDbKey,
        'language': 'es-MX'
      }));

  List<Actor> _jsonToActors(Map<String, dynamic> json) {
    final castResponse = CreditsResponse.fromJson(json);

    List<Actor> actors = castResponse.cast.map((e) {
      return ActorMapper.castToEntity(e);
    }).toList();

    return actors;
  }

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    return _jsonToActors(response.data);
  }
}
