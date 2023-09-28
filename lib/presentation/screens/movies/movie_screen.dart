import 'package:animate_do/animate_do.dart';
import 'package:cinema/config/helpers/human_formats.dart';
import 'package:cinema/config/helpers/whats_path_link.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/presentation/widgets/actors/actors_by_movie.dart';
import 'package:cinema/presentation/widgets/videos/videos_from_movie.dart';
import 'package:cinema/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const String name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(movieInfoProvider);
    final Movie? movie = movies[widget.movieId];

    if (movie == null) {
      return const Center(
        child: Scaffold(
            body: Center(
                child: CircularProgressIndicator(
          strokeWidth: 2,
        ))),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliderAppBar(
            movie: movie,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) {
                return _MovieDetails(
                  movie: movie,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Titulo, OverView y Rating
        _TitleAndOverview(movie: movie, size: size, textStyles: textStyle),

        //* Generos de la película
        _Genres(movie: movie),

        //* Actores de la película
        ActorsByMovie(
          movieId: movie.id.toString(),
        ),

        //* Videos de la película (si tiene)
        VideosFromMovie(movieId: movie.id),

        //* Películas similares
        SimilarMovies(movieId: movie.id),
      ],
    );
  }
}

class _TitleAndOverview extends StatelessWidget {
  const _TitleAndOverview({
    required this.movie,
    required this.size,
    required this.textStyles,
  });

  final Movie movie;
  final Size size;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeIn(
              child: WhatsPathLink.isInternetLink(movie.posterPath)
                  ? Image.network(
                      movie.posterPath,
                      width: size.width * 0.3,
                    )
                  : Image.asset(
                      movie.posterPath,
                      width: size.width * 0.3,
                    ),
            ),
          ),

          const SizedBox(width: 10),

          // Descripción
          SizedBox(
            width: (size.width - 60) * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.originalTitle, style: textStyles.titleLarge),
                Text(movie.overview),
                const SizedBox(height: 10),
                MovieRating(voteAverage: movie.voteAverage),
                Row(
                  children: [
                    const Text('Estreno:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(HumanFormats.shortDate(movie.releaseDate))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Genres extends StatelessWidget {
  const _Genres({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.start,
          children: [
            ...movie.genreIds.map((gender) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(gender),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomSliderAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliderAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final AsyncValue isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
            onPressed: () async {
              //await ref.read(localStorageRepositoryProvider).toggleFavorite(movie);
              await ref
                  .read(favoriteMovieProvider.notifier)
                  .toggleFavorite(movie);
              ref.invalidate(isFavoriteProvider(movie.id));
            },
            icon: isFavoriteFuture.when(
              data: (isFavorite) => isFavorite
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.red,
                        size: 40,
                      ))
                  : Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 40,
                      )),
              error: (error, stackTrace) {
                throw UnimplementedError();
              },
              loading: () {
                return const CircularProgressIndicator(
                  strokeWidth: 2,
                );
              },
            )

            //icon: Icon(Icons.favorite_border, ),
            //icon: Container(margin: EdgeInsets.fromLTRB(0, 0, 20, 0), child: Icon(Icons.favorite_rounded,color: Colors.red,size: 40, )),
            //icon: Container(margin: const EdgeInsets.fromLTRB(0, 0, 20, 0), child: const Icon(Icons.favorite_border,size: 40 , )),
            )
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: FadeIn(
                child: WhatsPathLink.isInternetLink(movie.posterPath)
                    ? Image.network(
                        movie.posterPath,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress != null) return const SizedBox();
                          return FadeIn(child: child);
                        },
                      )
                    : Image.asset(
                        movie.posterPath,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const _CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.8, 1.0],
              colors: [Colors.transparent, Colors.black87],
            ),
            const _CustomGradient(
              begin: Alignment.topLeft,
              stops: [0.0, 0.3],
              colors: [Colors.black87, Colors.transparent],
            ),
            const _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.2],
              colors: [Colors.black87, Colors.transparent],
            )
          ],
        ),
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        title: Text(
          movie.originalTitle,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required this.stops,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: begin, end: end, stops: stops, colors: colors)),
      ),
    );
  }
}
