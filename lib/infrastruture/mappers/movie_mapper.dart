// ignore_for_file: unnecessary_null_comparison

import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/infrastruture/models/moviedb/movie_details.dart';
import 'package:cinema/infrastruture/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != null && moviedb.backdropPath != '' && moviedb.backdropPath != 'null')
          ? 'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
          : 'assets/loaders/no-posts-found.jpg',
      genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != null && moviedb.posterPath != '' && moviedb.posterPath != 'null')
          ? 'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
          : 'assets/loaders/no-posts-found.jpg',
      releaseDate:
          moviedb.releaseDate != null ? moviedb.releaseDate! : DateTime.now(),
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount);

  static Movie movieDetailsToEntity(MovieDetails moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != null && moviedb.backdropPath != '' && moviedb.backdropPath != 'null')
          ? 'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
          : 'assets/loaders/no-posts-found.jpg',
      genreIds: moviedb.genres.map((e) => e.name).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != null && moviedb.posterPath != '' && moviedb.posterPath != 'null')
          ? 'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
          : 'assets/loaders/no-posts-found.jpg',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount);
}
