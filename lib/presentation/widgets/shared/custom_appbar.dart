import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/presentation/delegate/search_movie_delegate.dart';
import 'package:cinema/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final bool isDarkmode = ref.watch(themeNotifierProvider).isDarkmode;

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.movie_rounded,
                      color: colors.primary,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Cinema',
                      style: titleStyle,
                    )
                  ],
                ),
              ),
              //* const Spacer(),
              IconButton(
                onPressed: () {
                  final searchMovie = ref.read(searchMoviesProvider);
                  final searchQuery = ref.read(searchQueryProvider);

                  showSearch<Movie?>(
                          query: searchQuery,
                          context: context,
                          delegate: SearchMovieDelegate(
                              initialMovies: searchMovie,
                              searchMovies: ref
                                  .read(searchMoviesProvider.notifier)
                                  .searchMoviesByQuery))
                      .then((movie) {
                    if (movie != null) {
                      return context.go('/home/0/movie/${movie.id}');
                    }
                  });
                },
                icon: const Icon(Icons.search),
                color: colors.primary,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () {
                        ref
                            .read(themeNotifierProvider.notifier)
                            .toggleDarkmode();
                      },
                      icon: isDarkmode
                          ? const Icon(Icons.light_mode_outlined)
                          : const Icon(Icons.dark_mode_outlined)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
