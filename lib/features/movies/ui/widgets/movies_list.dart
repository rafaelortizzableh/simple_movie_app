import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../movies.dart';

class MoviesList extends StatelessWidget {
  const MoviesList({
    super.key,
    required this.movies,
    required this.loadingMore,
    required this.scrollController,
    required this.onReload,
  });

  final List<Movie> movies;
  final bool loadingMore;
  final ScrollController scrollController;
  final Future<void> Function() onReload;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: onReload,
          child: ListView.separated(
            controller: scrollController,
            itemCount: movies.length,
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieTile(movie: movie);
            },
          ),
        ),
        _AnimatedLoadingIndicator(loadingMore: loadingMore),
      ],
    );
  }
}

class _AnimatedLoadingIndicator extends StatelessWidget {
  const _AnimatedLoadingIndicator({
    // ignore: unused_element
    super.key,
    required this.loadingMore,
  });

  final bool loadingMore;

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      curve: Curves.easeInOut,
      alignment:
          loadingMore ? Alignment.bottomCenter : const Alignment(0.0, 1.5),
      duration: const Duration(milliseconds: 150),
      child: AnimatedPadding(
        padding: EdgeInsets.only(
          bottom: loadingMore ? AppConstants.spacing32 : 0.0,
        ),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: loadingMore ? 1 : 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: AppConstants.padding8,
              child: SizedBox(
                height: AppConstants.spacing24,
                width: AppConstants.spacing24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
