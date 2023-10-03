import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';

import '../movies.dart';

final movieListControllerProvider =
    StateNotifierProvider.autoDispose<MovieListController, MovieListState>(
  (ref) => MovieListController(
    ref.watch(movieRepositoryProvider),
  ),
);

class MovieListController extends StateNotifier<MovieListState> {
  MovieListController(
    this._movieRepository,
  ) : super(const MovieListState.initial());

  final MovieRepository _movieRepository;

  Future<void> reloadPopularMovies() async {
    state = const MovieListState.initial();
    await getPopularMovies();
  }

  Future<void> getPopularMovies() async {
    final pageToFetch = state.page + 1;
    final loadingMore = pageToFetch > 1;
    if (pageToFetch > 1) {
      state = state.copyWith(loadingMore: loadingMore);
    }

    final result = (await Future.wait([
      _movieRepository.getPopularMovies(pageToFetch),
      // As the API is very fast, we need to wait
      // a little bit to see the loading indicator.
      //
      // Showing it gives a more natural feeling to the user.
      if (loadingMore) Future.delayed(const Duration(seconds: 1)),
    ]))
        .first as Result<List<Movie>, MovieFailure>;

    result.when(
      (movies) {
        final currentMovies = state.movies.asData?.value ?? [];
        final newMovies = {...currentMovies, ...movies};
        state = state.copyWith(
          movies: AsyncValue.data(newMovies.toList()),
          loadingMore: false,
          page: pageToFetch,
        );
      },
      (failure) => state = state.copyWith(
        loadingMore: false,
        movies: AsyncValue.error(
          failure,
          StackTrace.current,
        ),
      ),
    );
  }
}
