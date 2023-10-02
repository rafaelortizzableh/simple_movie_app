import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../core/core.dart';
import '../movies.dart';

final movieRepositoryProvider = Provider.autoDispose<MovieRepository>(
  (ref) => MovieRepository(
    ref.watch(movieServiceProvider),
  ),
);

class MovieRepository {
  const MovieRepository(
    this._movieService,
  );

  final MovieService _movieService;

  Future<Result<List<Movie>, MovieFailure>> getPopularMovies(
    int page,
  ) async {
    try {
      final movieRemoteEntities = await _movieService.getPopularMovies(page);
      final movies = movieRemoteEntities
          .map(
            (movieRemoteEntity) => movieRemoteEntity.toMovie(),
          )
          .toList();

      return Result.success(movies);
    } catch (e) {
      return Result.error(_handleError(e));
    }
  }

  MovieFailure _handleError(Object error) {
    if (error is NoInternetConnectionFailure) {
      return MovieFailure(
        type: MovieFailureType.noInternetConnection,
      );
    }

    if (error is SerializationFailure) {
      return MovieFailure(
        type: MovieFailureType.serializationError,
      );
    }

    if (error is ApiInvalidResponseFailure ||
        error is ApiCancelledFailure ||
        error is ApiRequestFailure ||
        error is ApiTimeoutFailure) {
      return MovieFailure(
        type: MovieFailureType.serverError,
      );
    }

    return MovieFailure(
      type: MovieFailureType.unknown,
    );
  }
}
