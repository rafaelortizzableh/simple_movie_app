import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../movies.dart';

class MovieSearchState {
  const MovieSearchState({
    required this.query,
    required this.movies,
    required this.loadingMore,
    required this.page,
    required this.debouncedQueryCandidate,
  });

  factory MovieSearchState.initial() {
    return const MovieSearchState(
      query: '',
      debouncedQueryCandidate: '',
      movies: AsyncValue.loading(),
      loadingMore: false,
      page: 0,
    );
  }

  final String query;
  final String debouncedQueryCandidate;
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
        other.page == page &&
        other.debouncedQueryCandidate == debouncedQueryCandidate;
  }

  @override
  int get hashCode {
    return query.hashCode ^
        movies.hashCode ^
        loadingMore.hashCode ^
        page.hashCode ^
        debouncedQueryCandidate.hashCode;
  }

  MovieSearchState copyWith({
    String? query,
    AsyncValue<List<Movie>>? movies,
    bool? loadingMore,
    int? page,
    String? debouncedQueryCandidate,
  }) {
    return MovieSearchState(
      query: query ?? this.query,
      movies: movies ?? this.movies,
      loadingMore: loadingMore ?? this.loadingMore,
      page: page ?? this.page,
      debouncedQueryCandidate:
          debouncedQueryCandidate ?? this.debouncedQueryCandidate,
    );
  }

  @override
  String toString() {
    return 'MovieSearchState(query: $query, movies: $movies, loadingMore: $loadingMore, page: $page, debouncedQueryCandidate: $debouncedQueryCandidate)';
  }
}
