import 'package:cinema/presentation/providers/providers.dart';
import 'package:cinema/presentation/views/movies/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  final int indexPage;
  const FavoritesView({required this.indexPage, super.key});

  @override
  ConsumerState<FavoritesView> createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView>
    with AutomaticKeepAliveClientMixin {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadNextPage();
  }

  void loadNextPage() async {
    if (isLastPage || isLoading) {
      return;
    }

    isLoading = true;
    final movies =
        await ref.read(favoriteMovieProvider.notifier).loadNextPage();

    isLoading = false;
    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final favoriteMovies = ref.watch(favoriteMovieProvider).values.toList();

    if (favoriteMovies.isEmpty) {
      final colors = Theme.of(context).colorScheme;

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 60,
              color: colors.primary,
            ),
            Text(
              'Ohhh no!!',
              style: TextStyle(fontSize: 30, color: colors.primary),
            ),
            Text(
              'No tienes películas favoritas!!',
              style: TextStyle(fontSize: 20, color: colors.secondary),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton.tonal(
              onPressed: () {
                context.go('/home/0');
              },
              child: const Text('Empieza a buscar'),
            )
          ],
        ),
      );
    }

    return MovieMasonry(
        indexPage: widget.indexPage,
        movies: favoriteMovies,
        loadNextPage: loadNextPage);
  }

  @override
  bool get wantKeepAlive => true;
}
