import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MovieMasonry extends StatefulWidget {
  final int indexPage;
  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MovieMasonry(
      {super.key,
      required this.movies,
      this.loadNextPage,
      required this.indexPage});

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 100) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3,
        itemCount: widget.movies.length,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                MoviePosterLink(
                    indexPage: widget.indexPage, movie: widget.movies[index])
              ],
            );
          }
          return MoviePosterLink(
              indexPage: widget.indexPage, movie: widget.movies[index]);
        },
      ),
    );
  }
}
