import 'package:flutter/material.dart';

import '../../features.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie viewer'),
        actions: const [
          MovieSearchIcon(),
        ],
      ),
      body: const PopularMoviesDataWrapper(),
    );
  }
}
