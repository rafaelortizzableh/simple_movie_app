import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_movie_app/features/features.dart';

void main() {
  group('MovieRemoteEntity', () {
    late final String movieJson;

    setUpAll(() {
      movieJson = _exampleMovieJson;
    });
    test(
      'Given a JSON with a valid movie, '
      'when fromJson is called, '
      'then a MovieRemoteEntity is returned',
      () async {
        final movieRemoteEntity = MovieRemoteEntity.fromJson(movieJson);

        expect(movieRemoteEntity, isA<MovieRemoteEntity>());
        expect(
          movieRemoteEntity.title,
          'Harry Potter and the Philosopher\'s Stone',
        );
      },
    );

    test(
      'Given a <Map<String, dynamic>> with a valid movie, '
      'when fromMap is called, '
      'then a MovieRemoteEntity is returned',
      () async {
        final movieMap = json.decode(movieJson) as Map<String, dynamic>;
        final movieRemoteEntity = MovieRemoteEntity.fromMap(movieMap);

        expect(movieRemoteEntity, isA<MovieRemoteEntity>());
        expect(
          movieRemoteEntity.title,
          'Harry Potter and the Philosopher\'s Stone',
        );
      },
    );

    test(
      'Given a MovieRemoteEntity, '
      'when toMovie is called, '
      'then a Movie is returned',
      () async {
        final movieRemoteEntity = MovieRemoteEntity.fromJson(movieJson);
        final movie = movieRemoteEntity.toMovie();

        expect(movie, isA<Movie>());
        expect(movie.title, 'Harry Potter and the Philosopher\'s Stone');
      },
    );
  });
}

const _exampleMovieJson = '''
{
  "adult": false,
  "backdrop_path": "/hziiv14OpD73u9gAak4XDDfBKa2.jpg",
  "genre_ids": [
    12,
    14
  ],
  "id": 671,
  "original_language": "en",
  "original_title": "Harry Potter and the Philosopher's Stone",
  "overview": "Harry Potter has lived under the stairs at his aunt and uncle's house his whole life. But on his 11th birthday, he learns he's a powerful wizard—with a place waiting for him at the Hogwarts School of Witchcraft and Wizardry. As he learns to harness his newfound powers with the help of the school's kindly headmaster, Harry uncovers the truth about his parents' deaths—and about the villain who's to blame.",
  "popularity": 155.419,
  "poster_path": "/wuMc08IPKEatf9rnMNXvIDxqP4W.jpg",
  "release_date": "2001-11-16",
  "title": "Harry Potter and the Philosopher's Stone",
  "video": false,
  "vote_average": 7.9,
  "vote_count": 25381
}
''';
