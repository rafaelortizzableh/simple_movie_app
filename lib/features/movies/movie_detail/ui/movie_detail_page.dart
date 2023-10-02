import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../movies.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({
    super.key,
    required this.movie,
  });

  static const routeName = '/movie-detail';

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: AppConstants.padding12,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (movie.posterPath != null) ...[
                      MovieDetailPoster(
                        moviePosterUrl: movie.posterPath!,
                      ),
                    ],
                    Positioned(
                      bottom: -AppConstants.spacing24,
                      left: AppConstants.spacing24,
                      child: MovieDetailScore(
                        score: movie.voteAverage,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: AppConstants.padding12,
                child: Text(movie.overview),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
