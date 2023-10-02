import 'package:flutter/foundation.dart';

@immutable
class Movie {
  const Movie({
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
    this.backdropPath,
    this.posterPath,
    required this.id,
    required this.thumbnailPosterPath,
  });

  const Movie.empty()
      : title = '',
        overview = '',
        voteAverage = 0,
        id = 0,
        releaseDate = '',
        backdropPath = '',
        posterPath = '',
        thumbnailPosterPath = '';

  final String title;
  final String overview;
  final double voteAverage;
  final String releaseDate;
  final String? backdropPath;
  final String? posterPath;
  final String? thumbnailPosterPath;
  final int id;

  Movie copyWith({
    String? title,
    String? overview,
    double? voteAverage,
    String? releaseDate,
    String? backdropPath,
    String? posterPath,
    String? thumbnailPosterPath,
    int? id,
  }) {
    return Movie(
      title: title ?? this.title,
      overview: overview ?? this.overview,
      voteAverage: voteAverage ?? this.voteAverage,
      releaseDate: releaseDate ?? this.releaseDate,
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      thumbnailPosterPath: thumbnailPosterPath ?? this.thumbnailPosterPath,
      id: id ?? this.id,
    );
  }

  @override
  String toString() {
    return 'Movie(title: $title, overview: $overview, voteAverage: $voteAverage, releaseDate: $releaseDate, backdropPath: $backdropPath, posterPath: $posterPath, thumbnailPosterPath: $thumbnailPosterPath, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Movie &&
        other.title == title &&
        other.overview == overview &&
        other.voteAverage == voteAverage &&
        other.releaseDate == releaseDate &&
        other.backdropPath == backdropPath &&
        other.posterPath == posterPath &&
        other.thumbnailPosterPath == thumbnailPosterPath &&
        other.id == id;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        overview.hashCode ^
        voteAverage.hashCode ^
        releaseDate.hashCode ^
        backdropPath.hashCode ^
        posterPath.hashCode ^
        thumbnailPosterPath.hashCode ^
        id.hashCode;
  }
}
