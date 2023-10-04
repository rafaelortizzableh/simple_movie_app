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
    final theme = Theme.of(context);
    return AnimatedAlign(
      curve: Curves.fastOutSlowIn,
      alignment: _alignment,
      duration: _slideDuration,
      child: AnimatedPadding(
        padding: EdgeInsets.only(bottom: _bottomPadding),
        duration: _slideDuration,
        curve: Curves.fastOutSlowIn,
        child: AnimatedOpacity(
          duration: _opacityDuration,
          opacity: _opacity,
          child: AnimatedSwitcher(
            duration: _switcherDuration,
            reverseDuration: _switcherDuration,
            child: loadingMore
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: AppConstants.padding8,
                      child: SizedBox(
                        height: AppConstants.spacing24,
                        width: AppConstants.spacing24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: _strokeWidth,
                        ),
                      ),
                    ),
                  )
                : AppSpacingWidgets.emptySpace,
          ),
        ),
      ),
    );
  }

  Alignment get _alignment =>
      loadingMore ? Alignment.bottomCenter : const Alignment(0.0, 1.5);

  double get _opacity => loadingMore ? 1.0 : 0.0;

  double get _bottomPadding => loadingMore ? AppConstants.spacing24 : 0.0;

  static const _strokeWidth = 2.5;

  static const _slideDuration = Duration(milliseconds: 150);
  static const _opacityDuration = Duration(milliseconds: 300);
  static const _switcherDuration = Duration(milliseconds: 25);
}
