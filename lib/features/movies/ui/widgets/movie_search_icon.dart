import 'package:flutter/material.dart';

import '../../movies.dart';

class MovieSearchIcon extends StatelessWidget {
  const MovieSearchIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        showSearch(
          context: context,
          delegate: MoviesSearchDelegate(),
        );
      },
    );
  }
}
