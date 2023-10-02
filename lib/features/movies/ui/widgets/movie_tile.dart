import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../movies.dart';

class MovieTile extends StatelessWidget {
  const MovieTile({
    super.key,
    required this.movie,
  });
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: _leadingBackgroundImage,
        child: _LeadingChild(
          thumbnailPosterPath: movie.thumbnailPosterPath,
        ),
      ),
      title: Text(movie.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _navigateToDetailPage(context),
    );
  }

  void _navigateToDetailPage(BuildContext context) {
    unawaited(Navigator.of(context).pushNamed(
      MovieDetailPage.routeName,
      arguments: movie,
    ));
  }

  NetworkImage? get _leadingBackgroundImage {
    if (movie.thumbnailPosterPath == null ||
        movie.thumbnailPosterPath!.isEmpty) {
      return null;
    }

    return NetworkImage(movie.thumbnailPosterPath!);
  }
}

class _LeadingChild extends StatelessWidget {
  const _LeadingChild({
    // ignore: unused_element
    super.key,
    required this.thumbnailPosterPath,
  });

  final String? thumbnailPosterPath;

  @override
  Widget build(BuildContext context) {
    if (thumbnailPosterPath == null) {
      return const Icon(Icons.movie_creation_outlined);
    }

    if (thumbnailPosterPath!.isEmpty) {
      return const Icon(Icons.movie_creation_outlined);
    }

    return AppSpacingWidgets.emptySpace;
  }
}
