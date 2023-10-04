import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:simple_movie_app/features/features.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('MovieSearchController', () {
    late MovieRepository movieRepository;
    late List<Movie> movies;

    setUp(() {
      movieRepository = MockMovieRepository();
      movies = List.generate(
        10,
        (index) => Movie(
          id: index,
          title: 'title $index',
          overview: 'overview $index',
          posterPath: 'posterPath $index',
          thumbnailPosterPath: 'thumbnailPosterPath $index',
          backdropPath: 'backdropPath $index',
          voteAverage: index.toDouble(),
          releaseDate: 'releaseDate $index',
        ),
      );
    });

    setUpAll(() {
      registerFallbackValue(CancelToken());
    });

    test(
      'Given a controller, '
      'when the user types a valid query, '
      'then the controller should update the state with the results.',
      () async {
        final controller = MovieSearchController(movieRepository);
        const query = 'query';
        final expectedMovies = movies;

        when(() => movieRepository.searchMovies(
              query: query,
              page: 1,
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer(
          (_) async => Result.success(expectedMovies),
        );

        await controller.debounceSearch(query);

        final state = await controller.stream.firstWhere(
          (element) => element.movies.asData?.value.isNotEmpty ?? false,
          orElse: () => controller.state,
        );

        final firstMovie = state.movies.asData?.value.first;

        expect(
          firstMovie,
          expectedMovies.first,
        );
      },
    );

    test(
      'Given a controller, '
      'when the user types an invalid query, '
      'then the controller should update the state with a MoviesNotFound exception.',
      () async {
        final controller = MovieSearchController(movieRepository);
        const query = 'query';

        when(() => movieRepository.searchMovies(
              query: query,
              page: 1,
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer(
          (_) async => Result.error(
            MovieFailure(
              type: MovieFailureType.noMoviesFound,
            ),
          ),
        );

        await controller.debounceSearch(query);

        final state = await controller.stream.firstWhere(
          (element) => element.movies.asError?.error is MovieFailure,
          orElse: () => controller.state,
        );

        expect(
          state.movies.asError?.error,
          MovieFailure(
            type: MovieFailureType.noMoviesFound,
          ),
        );
      },
    );

    test(
      'Given a controller'
      'when the user types query and then updates before the debounce time, '
      'then the controller should update the state only with the results of the new query',
      () async {
        final controller = MovieSearchController(movieRepository);
        const query = 'query';
        const newQuery = 'newQuery';
        final expectedMovies = [
          const Movie(
            id: 1,
            title: 'title 1',
            overview: 'overview 1',
            posterPath: 'posterPath 1',
            thumbnailPosterPath: 'thumbnailPosterPath 1',
            backdropPath: 'backdropPath 1',
            voteAverage: 1,
            releaseDate: 'releaseDate 1',
          ),
        ];

        when(() => movieRepository.searchMovies(
              query: query,
              page: 1,
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer(
          (_) async => Result.success(movies),
        );

        when(() => movieRepository.searchMovies(
              query: newQuery,
              page: 1,
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer(
          (_) async => Result.success(expectedMovies),
        );

        await controller.debounceSearch(query);
        await controller.debounceSearch(newQuery);

        final state = await controller.stream.firstWhere(
          (element) => element.movies.asData?.value.isNotEmpty ?? false,
          orElse: () => controller.state,
        );

        final firstMovie = state.movies.asData?.value.first;

        expect(
          firstMovie,
          expectedMovies.first,
        );
      },
    );
  });
}
