import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class MovieSearchDataWrapper extends ConsumerStatefulWidget {
  const MovieSearchDataWrapper({
    super.key,
    required this.query,
  });

  final String query;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MovieSearchDataWrapperState();
}

class _MovieSearchDataWrapperState
    extends ConsumerState<MovieSearchDataWrapper> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _debouncedSearch(widget.query);
    _scrollController.addListener(_paginationListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MovieSearchDataWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      _debouncedSearch(widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchedMoviesState = ref.watch(
      movieSearchControllerProvider,
    );

    return searchedMoviesState.movies.when(
      data: (movies) {
        return MoviesList(
          movies: movies,
          loadingMore: searchedMoviesState.loadingMore,
          scrollController: _scrollController,
          onReload: () async => _refresh(),
        );
      },
      error: (error, stackTrace) {
        final errorText = _assignErrorMessage(error);
        return GenericError(
          errorText: errorText,
          onRetry: () async => _refresh(),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }

  void _debouncedSearch(String query) {
    final controller = ref.read(
      movieSearchControllerProvider.notifier,
    );
    Future(
      () => unawaited(controller.debounceSearch(query)),
    );
  }

  void _paginationListener() {
    final scrollDelta = _scrollController.position.maxScrollExtent -
        _scrollController.position.pixels;

    final normalizedDelta = scrollDelta.toInt();

    if (normalizedDelta <= 50 && normalizedDelta >= 0) {
      _fetchMoreMoviesFromQuery();
    }
  }

  void _fetchMoreMoviesFromQuery() {
    final isLoadingMore = ref.read(movieSearchControllerProvider).loadingMore;
    if (isLoadingMore) return;
    final controller = ref.read(
      movieSearchControllerProvider.notifier,
    );

    unawaited(
      controller.searchMovies(),
    );
  }

  void _refresh() {
    ref.invalidate(movieSearchControllerProvider);
  }

  String _assignErrorMessage(Object error) {
    if (error is MovieFailure) {
      return error.message;
    } else {
      return 'Oops! Something went wrong. Please try again later.';
    }
  }
}
