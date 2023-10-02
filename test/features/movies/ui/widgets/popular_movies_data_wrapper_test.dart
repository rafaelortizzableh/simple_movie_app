import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_movie_app/core/core.dart';
import 'package:simple_movie_app/features/features.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('PopularMoviesDataWrapper', () {
    late MovieService movieService;
    late List<MovieRemoteEntity> fakeRemoteEntities;

    setUp(
      () {
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
      },
    );

    testWidgets(
      'Given a loading state, '
      'when PopularMoviesDataWrapper is rendered, '
      'then a CircularProgressIndicator is shown.',
      (tester) async {
        await tester.pumpApp(
          const PopularMoviesDataWrapper(),
          overrides: [
            movieServiceProvider.overrideWithValue(
              movieService,
            )
          ],
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'Given a success state, '
      'when PopularMoviesDataWrapper is rendered, '
      'then a list of MovieTile is shown.',
      (tester) async {
        when(
          () => movieService.getPopularMovies(
            1,
          ),
        ).thenAnswer((value) async => fakeRemoteEntities);
        await tester.pumpApp(
          const PopularMoviesDataWrapper(),
          overrides: [
            movieServiceProvider.overrideWithValue(
              movieService,
            )
          ],
        );

        await tester.pumpAndSettle();

        expect(find.byType(MovieTile), findsWidgets);
      },
    );

    testWidgets(
      'Given an error state, '
      'when PopularMoviesDataWrapper is rendered, '
      'then a GenericError widget is shown.',
      (tester) async {
        when(
          () => movieService.getPopularMovies(
            1,
          ),
        ).thenThrow(
          const NoInternetConnectionFailure(),
        );
        await tester.pumpApp(
          const PopularMoviesDataWrapper(),
          overrides: [
            movieServiceProvider.overrideWithValue(
              movieService,
            )
          ],
        );

        await tester.pumpAndSettle();

        expect(find.byType(GenericError), findsOneWidget);
      },
    );
  });
}
