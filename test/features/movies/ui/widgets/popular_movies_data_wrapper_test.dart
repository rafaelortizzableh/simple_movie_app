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
      'Given a success state, '
      'when the user scrolls to the bottom of the list, '
      'then a new list containing values from page 1 and 2 is shown.',
      (tester) async {
        final pageOneRemoteEntities = _generateMovies(20);
        final pageTwoRemoteEntities = _generateMovies(20, 20);
        when(
          () => movieService.getPopularMovies(
            1,
          ),
        ).thenAnswer((value) async => pageOneRemoteEntities);
        when(
          () => movieService.getPopularMovies(
            2,
          ),
        ).thenAnswer((value) async => pageTwoRemoteEntities);

        await tester.pumpApp(
          const PopularMoviesDataWrapper(),
          overrides: [
            movieServiceProvider.overrideWithValue(
              movieService,
            )
          ],
        );

        await tester.pumpAndSettle();

        expect(find.byType(MovieTile, skipOffstage: false), findsWidgets);

        await tester.fling(
          find.byType(MovieTile).last,
          const Offset(0, -200),
          1000,
        );

        await tester.pumpAndSettle();
        final listFinder = find.byType(Scrollable);
        final itemFinder = find.text('title 22');

        await tester.scrollUntilVisible(
          itemFinder,
          500.0,
          scrollable: listFinder,
        );

        await tester.pumpAndSettle();

        expect(itemFinder, findsOneWidget);
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

List<MovieRemoteEntity> _generateMovies(int count, [int startFrom = 0]) {
  return List.generate(
    count,
    (index) => MovieRemoteEntity(
      title: 'title ${index + startFrom}',
      overview: 'overview ${index + startFrom}',
      voteAverage: 5.0,
      genreIds: [1],
      releaseDate: 'releaseDate $index',
      id: index + startFrom,
    ),
  );
}
