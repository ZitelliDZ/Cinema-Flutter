import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cinema/config/helpers/whats_path_link.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;
  final int indexPage;

  const MoviePosterLink({
    super.key,
    required this.movie,
    required this.indexPage,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return FadeInUp(
      from: random.nextInt(100) + 80,
      delay: Duration(milliseconds: random.nextInt(450) + 0),
      child: GestureDetector(
        onTap: () => context.push('/home/0/movie/${movie.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: WhatsPathLink.isInternetLink(movie.posterPath) ?
                          Image.network(movie.posterPath,height: 180,
            fit: BoxFit.cover,) : Image.asset(movie.posterPath,height: 180,
            fit: BoxFit.cover,),
          
        ),
      ),
    );
  }
}
