import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class MovieDetailPoster extends StatelessWidget {
  const MovieDetailPoster({
    super.key,
    required this.moviePosterUrl,
  });
  final String? moviePosterUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppConstants.borderRadius12,
      child: AspectRatio(
        aspectRatio: 0.75,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.25),
                Colors.transparent,
                Colors.black.withOpacity(0.25),
              ],
              stops: const [0, 0.5, 1],
            ),
          ),
          child: moviePosterUrl != null && moviePosterUrl!.isNotEmpty
              ? FadingNetworkImage(path: moviePosterUrl!)
              : const _FallbackPoster(),
        ),
      ),
    );
  }
}

class _FallbackPoster extends StatelessWidget {
  const _FallbackPoster();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: ColoredBox(
        color: AppConstants.primaryColor,
        child: Center(
          child: Icon(
            Icons.movie,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
