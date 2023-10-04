import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../movies.dart';

/// This is the provider for the [MovieSearchController].
final movieSearchControllerProvider =
    StateNotifierProvider.autoDispose<MovieSearchController, MovieSearchState>(
  (ref) {
    final movieRepository = ref.watch(movieRepositoryProvider);

    return MovieSearchController(movieRepository);
  },
);

class MovieSearchController extends StateNotifier<MovieSearchState> {
  MovieSearchController(
    this._movieRepository,
  ) : super(MovieSearchState.initial()) {
    _cancelToken = CancelToken();
  }

  Future<void> debounceSearch(String newQueryCantidate) async {
    final newQuery = newQueryCantidate.trim();
    if (newQuery == state.debouncedQueryCandidate) return;
    if (newQuery == state.query) return;
    state = state.copyWith(debouncedQueryCandidate: newQuery);

    await Future.delayed(const Duration(milliseconds: 750));
    if (state.debouncedQueryCandidate != newQuery) return;
    _firstSearch();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  final MovieRepository _movieRepository;
  late final CancelToken _cancelToken;

  void _firstSearch() {
    state = state.copyWith(
      query: state.debouncedQueryCandidate,
      debouncedQueryCandidate: '',
      movies: const AsyncValue.loading(),
      page: 0,
    );
    unawaited(searchMovies());
  }

  Future<void> searchMovies() async {
    if (!mounted) return;
    final pageToFetch = state.page + 1;
    final loadingMore = pageToFetch > 1;

    if (loadingMore) {
      state = state.copyWith(loadingMore: loadingMore);
    }

    if (!mounted) return;

    final result = (await Future.wait([
      _movieRepository.searchMovies(
        state.query,
        pageToFetch,
        _cancelToken,
      ),
      // As the API is very fast, we need to wait
      // a little bit to see the loading indicator.
      //
      // Showing it gives a more natural feeling to the user.
      if (loadingMore) Future.delayed(const Duration(seconds: 1)),
    ]))
        .first as Result<List<Movie>, MovieFailure>;

    if (!mounted) return;

    result.when(
      (movies) => state = state.copyWith(
        movies: AsyncValue.data(
          [
            ...state.movies.asData?.value ?? [],
            ...movies,
          ],
        ),
        page: pageToFetch,
        loadingMore: false,
      ),
      (error) => state = state.copyWith(
        movies: AsyncValue.error(error, StackTrace.current),
        loadingMore: false,
      ),
    );
  }
}
