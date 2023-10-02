import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../core/core.dart';
import 'model.dart';

class MovieRemoteEntity {
  const MovieRemoteEntity({
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.genreIds,
    required this.releaseDate,
    this.backdropPath,
    this.posterPath,
    required this.id,
  });

  final String title;
  final String overview;
  final double voteAverage;
  final List<int> genreIds;
  final String releaseDate;
  final String? backdropPath;
  final String? posterPath;
  final int id;

  static const _className = 'MovieRemoteEntity';

  factory MovieRemoteEntity.fromMap(Map<String, dynamic> map) {
    try {
      return MovieRemoteEntity(
        title: map['title'],
        overview: map['overview'],
        voteAverage: map['vote_average']?.toDouble(),
        genreIds: List<int>.from(map['genre_ids']),
        releaseDate: map['release_date'],
        backdropPath: map['backdrop_path'],
        posterPath: map['poster_path'],
        id: map['id']?.toInt(),
      );
    } catch (e) {
      throw const SerializationFailure(
        className: _className,
      );
    }
  }

  factory MovieRemoteEntity.fromJson(String source) =>
      MovieRemoteEntity.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieRemoteEntity &&
        other.title == title &&
        other.overview == overview &&
        other.voteAverage == voteAverage &&
        listEquals(other.genreIds, genreIds) &&
        other.releaseDate == releaseDate &&
        other.backdropPath == backdropPath &&
        other.posterPath == posterPath &&
        other.id == id;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        overview.hashCode ^
        voteAverage.hashCode ^
        genreIds.hashCode ^
        releaseDate.hashCode ^
        backdropPath.hashCode ^
        posterPath.hashCode ^
        id.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'overview': overview,
      'vote_average': voteAverage,
      'genre_ids': genreIds,
      'release_date': releaseDate,
      'backdrop_path': backdropPath,
      'poster_path': posterPath,
      'id': id,
    };
  }

  String toJson() => json.encode(toMap());
}

extension AdapterExtension on MovieRemoteEntity {
  Movie toMovie() {
    final movieEntity = this;
    return Movie(
      id: movieEntity.id,
      title: movieEntity.title,
      overview: movieEntity.overview,
      backdropPath: _appendUrlPrefix(
        movieEntity.backdropPath,
        _tmdb500ImageUrlPrefix,
      ),
      posterPath: _appendUrlPrefix(
        movieEntity.posterPath,
        _tmdb500ImageUrlPrefix,
      ),
      thumbnailPosterPath: _appendUrlPrefix(
        movieEntity.posterPath,
        _tmdbThumbnailImageUrlPrefix,
      ),
      voteAverage: movieEntity.voteAverage,
      releaseDate: movieEntity.releaseDate,
    );
  }

  String? _appendUrlPrefix(
    String? imageReference,
    String urlPrefix,
  ) {
    if (imageReference == null) return null;
    if (imageReference.startsWith('/')) return urlPrefix + imageReference;
    return '$urlPrefix/$imageReference';
  }

  static const _tmdb500ImageUrlPrefix = 'https://image.tmdb.org/t/p/w500';
  static const _tmdbThumbnailImageUrlPrefix = 'https://image.tmdb.org/t/p/w200';
}
