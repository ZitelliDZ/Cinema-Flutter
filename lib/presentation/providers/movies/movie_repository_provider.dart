import 'package:cinema/infrastruture/datasource/moviedb_datasource_impl.dart';
import 'package:cinema/infrastruture/repositories/movie_repositories_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// inmutable
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(datasource: MovieDbDatasourceImpl());
});
