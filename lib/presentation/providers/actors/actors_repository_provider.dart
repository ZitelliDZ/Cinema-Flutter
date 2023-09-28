import 'package:cinema/infrastruture/datasource/actor_moviedb_datasource_impl.dart';
import 'package:cinema/infrastruture/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// inmutable
final actorsRepositoryProvider = Provider((ref) {
  return ActorRepositoryImpl(datasource: ActorMoviedbDatasourceImpl());
});
