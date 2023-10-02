import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/core.dart';
import '../../movies.dart';

/// This is the provider for the [MovieSearchController].
final movieSearchControllerProvider = StateNotifierProvider.family
    .autoDispose<MovieSearchController, MovieSearchState, String>(
  (ref, String query) {
    final movieRepository = ref.watch(movieRepositoryProvider);
    final searchDebouncer = ref.watch(_searchDebouncerProvider);

    return MovieSearchController(
      movieRepository,
      query,
      searchDebouncer,
    );
  },
);

/// Search debouncer to avoid making too many requests.
/// It waits for half a second before making the request.
final _searchDebouncerProvider = Provider<Debouncer>(
  (ref) => Debouncer(delay: const Duration(milliseconds: 500)),
);

class MovieSearchController extends StateNotifier<MovieSearchState> {
  MovieSearchController(
    this._movieRepository,
    this._query,
    this._debouncer,
  ) : super(MovieSearchState.initial()) {
    _cancelToken = CancelToken();
    _debouncer.call(_init);
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  late final CancelToken _cancelToken;
  final MovieRepository _movieRepository;
  final String _query;
  final Debouncer _debouncer;

  void _init() {
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
        _query,
        pageToFetch,
        _cancelToken,
      ),
      // As the API is very fast, we need to wait
      // a little bit to see the loading indicator.
      //
      // Showing it gives a more natural feeling to the user.
      if (loadingMore) Future.delayed(const Duration(seconds: 750)),
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

class MovieSearchState {
  const MovieSearchState({
    required this.query,
    required this.movies,
    required this.loadingMore,
    required this.page,
  });

  factory MovieSearchState.initial() {
    return const MovieSearchState(
      query: '',
      movies: AsyncValue.loading(),
      loadingMore: false,
      page: 0,
    );
  }

  final String query;
  final AsyncValue<List<Movie>> movies;
  final bool loadingMore;
  final int page;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieSearchState &&
        other.query == query &&
        other.movies == movies &&
        other.loadingMore == loadingMore &&
        other.page == page;
  }

  @override
  int get hashCode {
    return query.hashCode ^
        movies.hashCode ^
        loadingMore.hashCode ^
        page.hashCode;
  }

  MovieSearchState copyWith({
    String? query,
    AsyncValue<List<Movie>>? movies,
    bool? loadingMore,
    int? page,
  }) {
    return MovieSearchState(
      query: query ?? this.query,
      movies: movies ?? this.movies,
      loadingMore: loadingMore ?? this.loadingMore,
      page: page ?? this.page,
    );
  }

  @override
  String toString() {
    return 'MovieSearchState(query: $query, movies: $movies, loadingMore: $loadingMore, page: $page)';
  }
}
