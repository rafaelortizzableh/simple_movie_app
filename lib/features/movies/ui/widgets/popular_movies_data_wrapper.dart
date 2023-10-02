import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../../movies.dart';

class PopularMoviesDataWrapper extends ConsumerStatefulWidget {
  const PopularMoviesDataWrapper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PopularMoviesDataWrapperState();
}

class _PopularMoviesDataWrapperState
    extends ConsumerState<PopularMoviesDataWrapper> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_paginationListener);
    _fetchInitialMovies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(movieListControllerProvider);

    return state.movies.when(
      data: (movies) {
        return MoviesList(
          movies: movies,
          loadingMore: state.loadingMore,
          scrollController: _scrollController,
          onReload: _onRetry,
        );
      },
      error: (error, stackTrace) {
        final errorText = _generateErrorText(error);
        return GenericError(
          errorText: errorText,
          onRetry: () => unawaited(_onRetry()),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  void _fetchInitialMovies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieListControllerProvider.notifier).getPopularMovies();
    });
  }

  void _paginationListener() {
    final delta = _scrollController.position.maxScrollExtent -
        _scrollController.position.pixels;
    if (delta < 25) {
      unawaited(
        ref.read(movieListControllerProvider.notifier).getPopularMovies(),
      );
    }
  }

  Future<void> _onRetry() {
    return ref.read(movieListControllerProvider.notifier).reloadPopularMovies();
  }

  String _generateErrorText(Object error) {
    if (error is MovieFailure) {
      return error.message;
    }
    return 'Something went wrong';
  }
}
