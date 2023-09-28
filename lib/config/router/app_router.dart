import 'package:cinema/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/home/0', routes: [
  GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final String pageIndex = state.pathParameters['page'] ?? '0';
        int page = int.parse(pageIndex);
        if (page > 2 || page < 0) page = 0;

        return WillPopScope(
          onWillPop: () async {
            context.go('/home/0');
            return false;
          },
          child: HomeScreen(
            pageIndex: page,
          ),
        );
      },
      routes: [
        GoRoute(
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return MovieScreen(
              movieId: movieId,
            );
          },
        )
      ]),
  GoRoute(
    path: '/',
    redirect: (context, state) {
      return '/home/0';
    },
  )
]);
