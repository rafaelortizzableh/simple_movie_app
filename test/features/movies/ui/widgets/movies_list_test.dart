import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_movie_app/features/features.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('MoviesList', () {
    late ScrollController scrollController;

    setUp(() {
      scrollController = ScrollController();
    });

    tearDown(() {
      scrollController.dispose();
    });

    testWidgets(
      'should display loading indicator when loading more',
      (tester) async {
        // Arrange
        await tester.pumpApp(MoviesList(
          movies: const [],
          loadingMore: true,
          onReload: () async {},
          scrollController: scrollController,
        ));

        // Act
        await tester.pump();

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'Should display two items when movies has two items',
      (tester) async {
        // Arrange
        final movies = [
          const Movie(
            id: 1,
            title: 'title 1',
            overview: 'overview 1',
            posterPath: '',
            thumbnailPosterPath: '',
            backdropPath: '',
            releaseDate: 'releaseDate 1',
            voteAverage: 1,
          ),
          const Movie(
            id: 2,
            title: 'title 2',
            overview: 'overview 2',
            posterPath: '',
            backdropPath: '',
            thumbnailPosterPath: '',
            releaseDate: 'releaseDate 2',
            voteAverage: 2,
          ),
        ];

        // Act
        await tester.pumpApp(MoviesList(
          movies: movies,
          loadingMore: false,
          onReload: () async {},
          scrollController: scrollController,
        ));

        // Assert
        expect(find.byType(MovieTile), findsNWidgets(2));
      },
    );
  });
}
