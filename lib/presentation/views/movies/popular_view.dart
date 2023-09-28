import 'package:cinema/presentation/providers/movies/movies_providers.dart';
import 'package:cinema/presentation/views/movies/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularView extends ConsumerStatefulWidget {
  final int indexPage;
  const PopularView({required this.indexPage, super.key});

  @override
  PopularViewState createState() => PopularViewState();
}

class PopularViewState extends ConsumerState<PopularView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final popularMovies = ref.watch(popularMoviesProvider);

    if (popularMovies.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return Scaffold(
      body: MovieMasonry(
          indexPage: widget.indexPage,
          loadNextPage: () =>
              ref.read(popularMoviesProvider.notifier).loadNextPage(),
          movies: popularMovies),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
