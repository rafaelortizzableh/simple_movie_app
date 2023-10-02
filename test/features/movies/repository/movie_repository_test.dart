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
  });
}
