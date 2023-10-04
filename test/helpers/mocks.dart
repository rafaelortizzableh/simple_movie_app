import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_movie_app/features/features.dart';

class MockMovieListController extends StateNotifier<MovieListState>
    with Mock
    implements MovieListController {
  MockMovieListController(super.state);

  void setState(MovieListState state) => this.state = state;
}

class MockMovieService extends Mock implements MovieService {}

class MockMovieRepository extends Mock implements MovieRepository {}
