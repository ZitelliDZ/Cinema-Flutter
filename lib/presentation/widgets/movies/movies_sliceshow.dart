import 'package:card_swiper/card_swiper.dart';
import 'package:cinema/config/helpers/whats_path_link.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviesSliceShow extends StatelessWidget {
  final List<Movie> movies;

  const MoviesSliceShow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 210,
      width: double.infinity,
      child: Swiper(
        viewportFraction: 0.8,
        scale: 0.9,
        autoplay: true,
        pagination: SwiperPagination(
            margin: const EdgeInsets.only(top: 0),
            builder: DotSwiperPaginationBuilder(
                activeColor: colors.primary, color: colors.secondary)),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return _Slide(
            movie: movies[index],
          );
        },
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Colors.black38, blurRadius: 10, offset: Offset(0, 13))
        ]);

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
          decoration: decoration,
          child: GestureDetector(
            onTap: () => context.go('/home/0/movie/${movie.id}'),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GestureDetector(
                        onTap: () => context.push('/home/0/movie/${movie.id}'),
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: const AssetImage(
                              'assets/loaders/bottle-loader.gif'),
                          image: WhatsPathLink.isInternetLink(movie.backdropPath) ?
                          NetworkImage(movie.backdropPath) : AssetImage(movie.backdropPath) as  ImageProvider,
                        ),
                      )),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const SizedBox.expand(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.8, 1.0],
                              colors: [Colors.transparent, Colors.black87])),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                  child: Text(
                    movie.originalTitle,
                    style: textStyle.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
