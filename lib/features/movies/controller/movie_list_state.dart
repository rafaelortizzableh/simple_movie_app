import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../movies.dart';

class MovieListState {
  const MovieListState({
    required this.movies,
    this.page = 0,
    this.loadingMore = false,
  });
  const MovieListState.initial()
      : movies = const AsyncValue.loading(),
        page = 0,
        loadingMore = false;

  final AsyncValue<List<Movie>> movies;
  final int page;
  final bool loadingMore;

  MovieListState copyWith({
    AsyncValue<List<Movie>>? movies,
    int? page,
    bool? loadingMore,
  }) {
    return MovieListState(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieListState &&
        other.movies == movies &&
        other.page == page &&
        other.loadingMore == loadingMore;
  }

  @override
  int get hashCode => movies.hashCode ^ page.hashCode ^ loadingMore.hashCode;

  @override
  String toString() =>
      'MovieListState(movies: $movies, page: $page, loadingMore: $loadingMore)';
}
