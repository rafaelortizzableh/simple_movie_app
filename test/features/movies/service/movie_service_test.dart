import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_movie_app/core/core.dart';
import 'package:simple_movie_app/features/features.dart';

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  group('TMDBMovieService', () {
    late MovieService service;
    late MockLoggerService mockLoggerService;
    late Dio dio;
    late DioAdapter dioAdapter;

    const baseUrl = 'https://api.themoviedb.org/3';
    const apiKey = 'apiKey';
    const headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
    };

    const queryParameters = {
      'api_key': apiKey,
      'language': 'en-US',
    };

    setUp(() {
      mockLoggerService = MockLoggerService();
      dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
        queryParameters: queryParameters,
        responseType: ResponseType.json,
      ));

      dioAdapter = DioAdapter(dio: dio, printLogs: true);
      service = TMDBMovieService(dio, mockLoggerService);
    });

    test(
        'Given a page number, '
        'when getPopularMovies is called, '
        'then a list of MovieRemoteEntity is returned', () async {
      final expectedMoviesRemoteEntities = [
        const MovieRemoteEntity(
          genreIds: [],
          id: 1,
          overview: 'Overview 1',
          posterPath: '/poster1.jpg',
          title: 'Movie 1',
          releaseDate: '',
          voteAverage: 5.0,
          backdropPath: '',
        ),
        const MovieRemoteEntity(
          genreIds: [],
          id: 2,
          overview: 'Overview 2',
          posterPath: '/poster2.jpg',
          title: 'Movie 2',
          releaseDate: '',
          voteAverage: 5.0,
          backdropPath: '',
        ),
      ];

      const path = '/movie/popular';
      dioAdapter.onGet(
        path,
        (server) => server.reply(
          HttpStatus.ok,
          {
            'results':
                expectedMoviesRemoteEntities.map((e) => e.toMap()).toList(),
          },
          delay: const Duration(milliseconds: 100),
        ),
        queryParameters: {'page': 1},
      );

      final movies = await service.getPopularMovies(page: 1);

      expect(movies, isA<List<MovieRemoteEntity>>());
      expect(movies.length, equals(2));
      expect(movies[0].id, equals(1));
      expect(movies[0].title, equals('Movie 1'));
      expect(movies[0].overview, equals('Overview 1'));
      expect(movies[0].posterPath, equals('/poster1.jpg'));
      expect(movies[1].id, equals(2));
      expect(movies[1].title, equals('Movie 2'));
      expect(movies[1].overview, equals('Overview 2'));
      expect(movies[1].posterPath, equals('/poster2.jpg'));
    });

    test(
        'Given no internet connection, '
        'when getPopularMovies is called, '
        'then a NoInternetConnectionFailure is thrown', () async {
      const path = '/movie/popular';
      dioAdapter.onGet(
        path,
        (server) => server.throws(
          404,
          DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: path),
            response: null,
          ),
          delay: const Duration(milliseconds: 100),
        ),
        queryParameters: {'page': 1},
      );

      expect(
        () async => await service.getPopularMovies(page: 1),
        throwsA(isA<NoInternetConnectionFailure>()),
      );
    });

    test(
      'Given a query string, '
      'when searchMovies is called, '
      'then a list of MovieRemoteEntity is returned',
      () async {
        // Given
        const query = 'Star Wars';
        final cancelToken = CancelToken();

        addTearDown(() => cancelToken.cancel());

        const path = '/search/movie';
        final expectedMoviesRemoteEntities = [
          const MovieRemoteEntity(
            genreIds: [],
            id: 1,
            overview: 'Overview 1',
            posterPath: '/poster1.jpg',
            title: 'Star Wars: Episode IV - A New Hope',
            releaseDate: '',
            voteAverage: 5.0,
            backdropPath: '',
          ),
          const MovieRemoteEntity(
            genreIds: [],
            id: 2,
            overview: 'Overview 2',
            posterPath: '/poster2.jpg',
            title: 'Star Wars: Episode V - The Empire Strikes Back',
            releaseDate: '',
            voteAverage: 5.0,
            backdropPath: '',
          ),
        ];

        dioAdapter.onGet(
          path,
          (server) => server.reply(
            HttpStatus.ok,
            {
              'total_results': 2,
              'results':
                  expectedMoviesRemoteEntities.map((e) => e.toMap()).toList(),
            },
            delay: const Duration(milliseconds: 100),
          ),
          queryParameters: {'page': 1},
        );

        // When
        final movies = await service.searchMovies(
          query: query,
          page: 1,
          cancelToken: cancelToken,
        );

        // Then
        expect(movies, equals(expectedMoviesRemoteEntities));
      },
    );
  });
}
