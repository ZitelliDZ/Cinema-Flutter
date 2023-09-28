import 'package:cinema/config/constants/environment.dart';
import 'package:cinema/domain/datasources/movie_datasource.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/domain/entities/video.dart';
import 'package:cinema/infrastruture/mappers/movie_mapper.dart';
import 'package:cinema/infrastruture/mappers/video_mapper.dart';
import 'package:cinema/infrastruture/models/moviedb/movie_details.dart';
import 'package:cinema/infrastruture/models/moviedb/moviedb_response.dart';
import 'package:cinema/infrastruture/models/moviedb/moviedb_videos.dart';
import 'package:dio/dio.dart';

class MovieDbDatasourceImpl extends MovieDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Enviroment.movieDbKey,
        'language': 'es-MX'
      }));

  List<Movie> _jsonToMovie(Map<String, dynamic> json) {
    final movieResponse = MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) {
      return MovieMapper.movieDBToEntity(moviedb);
    }).toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response =
        await dio.get('/movie/now_playing', queryParameters: {'page': page});

    return _jsonToMovie(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response =
        await dio.get('/movie/popular', queryParameters: {'page': page});

    return _jsonToMovie(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response =
        await dio.get('/movie/top_rated', queryParameters: {'page': page});

    return _jsonToMovie(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response =
        await dio.get('/movie/upcoming', queryParameters: {'page': page});

    return _jsonToMovie(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');

    if (response.statusCode != 200) {
      return throw Exception('Movie with id: $id not found');
    }

    final movieDb = MovieDetails.fromJson(response.data);

    final Movie movie = MovieMapper.movieDetailsToEntity(movieDb);

    return movie;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final response =
        await dio.get('/search/movie', queryParameters: {'query': query});

    return _jsonToMovie(response.data);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final response = await dio.get('/movie/$movieId/similar');
    return _jsonToMovie(response.data);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) async {
    final response = await dio.get('/movie/$movieId/videos');
    final moviedbVideosReponse = MoviedbVideosResponse.fromJson(response.data);
    final videos = <Video>[];

    for (final moviedbVideo in moviedbVideosReponse.results) {
      if (moviedbVideo.site == 'YouTube') {
        final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);
        videos.add(video);
      }
    }

    return videos;
  }
}
