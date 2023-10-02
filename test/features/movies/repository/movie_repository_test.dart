import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_movie_app/core/core.dart';
import 'package:simple_movie_app/features/features.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('MovieRepository', () {
    late MovieService movieService;
    late MovieRepository movieRepository;
    late List<MovieRemoteEntity> fakeRemoteEntities;

    setUp(() {
      movieService = MockMovieService();
      fakeRemoteEntities = [
        const MovieRemoteEntity(
          title: 'title',
          overview: 'overview',
          voteAverage: 5.0,
          genreIds: [1],
          releaseDate: 'releaseDate',
          id: 1,
        ),
      ];

      movieRepository = MovieRepository(movieService);
    });

    test(
      'Given an instance of MovieService and available internet connection, '
      'when getPopularMovies is called, '
      'then, the result is a `Success` with the expected list of `Movie`',
      () async {
        when(
          () => movieService.getPopularMovies(
            1,
          ),
        ).thenAnswer((value) async => fakeRemoteEntities);

        final result = await movieRepository.getPopularMovies(1);

        final expectedMovies = fakeRemoteEntities
            .map(
              (movieRemoteEntity) => movieRemoteEntity.toMovie(),
            )
            .toList();

        expect(result.isSuccess(), true);
        expect(result.tryGetSuccess(), expectedMovies);
      },
    );

    test(
      'Given an instance of MovieService and no internet connection, '
      'when getPopularMovies is called, '
      'then the correct MovieFailure should be returned as the result',
      () async {
        when(
          () => movieService.getPopularMovies(
            1,
          ),
        ).thenThrow(const NoInternetConnectionFailure());

        final result = await movieRepository.getPopularMovies(1);

        final expectedFailure = MovieFailure(
          type: MovieFailureType.noInternetConnection,
        );

        expect(result.isError(), true);
        expect(result.tryGetError(), expectedFailure);
      },
    );

    test(
      'Given an instance of MovieService and unserializable response data, '
      'when getPopularMovies is called, '
      'then the correct MovieFailure should be returned as the result',
      () async {
        when(
          () => movieService.getPopularMovies(
            1,
          ),
        ).thenThrow(const SerializationFailure(
          className: 'MovieRemoteEntity',
        ));

        final result = await movieRepository.getPopularMovies(1);

        final expectedFailure = MovieFailure(
          type: MovieFailureType.serializationError,
        );

        expect(result.isError(), true);
        expect(result.tryGetError(), expectedFailure);
      },
    );

    test(
      'Given a query string, '
      'when searchMovies is called, '
      'then a list of Movie should be returned',
      () async {
        // Given
        const query = 'Star Wars';
        final cancelToken = CancelToken();

        addTearDown(() => cancelToken.cancel());
        final expectedRemoteEntities = [
          const MovieRemoteEntity(
            id: 1,
            title: 'Star Wars: Episode IV - A New Hope',
            overview: 'Overview 1',
            posterPath: '/poster1.jpg',
            releaseDate: '',
            voteAverage: 5.0,
            backdropPath: '',
            genreIds: [],
          ),
          const MovieRemoteEntity(
            id: 2,
            title: 'Star Wars: Episode V - The Empire Strikes Back',
            overview: 'Overview 2',
            posterPath: '/poster2.jpg',
            releaseDate: '',
            voteAverage: 5.0,
            backdropPath: '',
            genreIds: [],
          ),
        ];

        when(() => movieService.searchMovies(query, 1, cancelToken))
            .thenAnswer((_) async => expectedRemoteEntities);

        // When
        final result = await movieRepository.searchMovies(
          query,
          1,
          cancelToken,
        );

        final expectedMovies = expectedRemoteEntities
            .map(
              (movieRemoteEntity) => movieRemoteEntity.toMovie(),
            )
            .toList();

        // Then
        expect(result.isSuccess(), true);
        expect(result.tryGetSuccess(), expectedMovies);
      },
    );

    test(
      'Given an instance of MovieService and a network error, '
      'when searchMovies is called, '
      'then the correct MovieFailure should be returned as the result',
      () async {
        // Given
        const query = 'Star Wars';
        final expectedFailure = MovieFailure(
          type: MovieFailureType.noInternetConnection,
        );
        final cancelToken = CancelToken();

        addTearDown(() => cancelToken.cancel());

        when(() => movieService.searchMovies(query, 1, cancelToken)).thenThrow(
          const NoInternetConnectionFailure(),
        );

        // When
        final result = await movieRepository.searchMovies(
          query,
          1,
          cancelToken,
        );

        // Then
        expect(result.isError(), true);
        expect(result.tryGetError(), expectedFailure);
      },
    );

    test(
      'Given an instance of MovieService and no movies found, '
      'when searchMovies is called, '
      'then the correct MovieFailure should be returned as the result',
      () async {
        // Given
        const query = 'Star Wars';
        final expectedFailure = MovieFailure(
          type: MovieFailureType.noMoviesFound,
        );
        final cancelToken = CancelToken();

        addTearDown(() => cancelToken.cancel());

        when(() => movieService.searchMovies(query, 1, cancelToken)).thenThrow(
          const NoMoviesFoundFailure(),
        );

        // When
        final result = await movieRepository.searchMovies(
          query,
          1,
          cancelToken,
        );

        // Then
        expect(result.isError(), true);
        expect(result.tryGetError(), expectedFailure);
      },
    );
  });
}
