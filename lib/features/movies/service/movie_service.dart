import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_movie_app/core/core.dart';

import '../movies.dart';

final _requestProvider = Provider.autoDispose<Dio>(
  (_) {
    final dio = Dio(
      BaseOptions(
        baseUrl: TMDBMovieService._baseUrl,
        queryParameters: {
          'api_key': TMDBMovieService._apiKey,
          'language': 'en-US',
        },
      ),
    );
    return dio;
  },
);

final movieServiceProvider = Provider.autoDispose<MovieService>(
  (ref) => TMDBMovieService(
    ref.watch(_requestProvider),
    ref.watch(loggerServiceProvider),
  ),
);

abstract class MovieService {
  Future<List<MovieRemoteEntity>> getPopularMovies(int page);
}

class TMDBMovieService implements MovieService {
  TMDBMovieService(
    this._dio,
    this._loggerService,
  );
  static const _baseUrl = 'https://api.themoviedb.org/3';
  static const _apiKey = String.fromEnvironment('TMDB_API_KEY');
  static const _tag = 'tmdb_movie_service';

  final Dio _dio;
  final LoggerService _loggerService;

  @override
  Future<List<MovieRemoteEntity>> getPopularMovies(int page) async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {
          'page': page,
        },
      );

      final results = response.data['results'] as List;

      final movies = results
          .map(
            (map) => MovieRemoteEntity.fromMap(
              map as Map<String, dynamic>,
            ),
          )
          .toList();
      return movies;
    } catch (e, stackTrace) {
      _loggerService.captureException(
        e,
        stackTrace: stackTrace,
        tag: _tag,
      );

      _handleError(e, stackTrace);
    }
  }

  Never _handleError(Object error, StackTrace stackTrace) {
    if (error is DioException) {
      _handleDioException(error, stackTrace);
    }
    if (error is SerializationFailure) {
      Error.throwWithStackTrace(
        error,
        stackTrace,
      );
    }

    Error.throwWithStackTrace(
      ApiRequestFailure(
        error: error,
      ),
      stackTrace,
    );
  }

  Never _handleDioException(DioException exception, StackTrace stackTrace) {
    if (exception.type == DioExceptionType.connectionError) {
      Error.throwWithStackTrace(
        const NoInternetConnectionFailure(),
        stackTrace,
      );
    }

    if (exception.type == DioExceptionType.badResponse) {
      final responseError = ApiInvalidResponseFailure(
        body: exception.response?.data ?? {},
        statusCode: exception.response?.statusCode ?? 400,
      );
      Error.throwWithStackTrace(responseError, stackTrace);
    }

    if (exception.type == DioExceptionType.cancel) {
      Error.throwWithStackTrace(
        ApiCancelledFailure(
          error: exception,
        ),
        stackTrace,
      );
    }

    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout) {
      Error.throwWithStackTrace(
        ApiTimeoutFailure(
          error: exception,
        ),
        stackTrace,
      );
    }

    Error.throwWithStackTrace(
      ApiRequestFailure(
        error: exception,
      ),
      stackTrace,
    );
  }
}
