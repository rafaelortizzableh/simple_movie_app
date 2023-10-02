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
    return RefreshIndicator(
      onRefresh: onReload,
      child: ListView.separated(
        controller: scrollController,
        itemCount: _listItemCount,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          if (index == movies.length) {
            return const _LoadingTile();
          }
          final movie = movies[index];
          return MovieTile(movie: movie);
        },
      ),
    );
  }

  int get _listItemCount {
    if (loadingMore) {
      return movies.length + 1;
    }
    return movies.length;
  }
}

class _LoadingTile extends StatelessWidget {
  const _LoadingTile();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: AppConstants.padding12,
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
