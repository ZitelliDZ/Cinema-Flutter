import 'package:path_provider/path_provider.dart';
import 'package:cinema/domain/datasources/local_storage_datasource.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class IsarDatasourceImpl extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasourceImpl() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = await getApplicationSupportDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([MovieSchema],
          directory: dir.path, inspector: true);
    }
    return await Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;

    final Movie? isFavoriteMovie =
        await isar.movies.filter().idEqualTo(movieId).findFirst();

    return isFavoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final isar = await db;

    final List<Movie> movies = await isar.movies
        .where(sort: Sort.desc)
        .anyIsarId()
        .offset(offset)
        .limit(limit)
        .findAll();

    return movies;
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await db;

    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();

    if (favoriteMovie != null) {
      //borrar
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
      return;
    }

    //insertar
    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }
}
