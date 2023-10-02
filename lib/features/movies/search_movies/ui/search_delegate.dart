import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../movies.dart';

class MoviesSearchDelegate extends SearchDelegate {
  MoviesSearchDelegate();

  @override
  String get searchFieldLabel => 'Search movies';

  @override
  TextStyle get searchFieldStyle => const TextStyle(
        color: Colors.black,
      );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
        ),
        toolbarTextStyle: TextStyle(
          color: Colors.black,
        ),
        foregroundColor: Colors.black,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          color: Colors.black.withOpacity(0.5),
        ),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      _ClearIcon(onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return const BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsAndSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResultsAndSuggestions(context);
  }

  Widget _buildResultsAndSuggestions(BuildContext context) {
    final query = this.query.trim().toLowerCase();
    final theme = Theme.of(context);

    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🔍',
              style: theme.textTheme.headlineMedium,
            ),
            AppSpacingWidgets.verticalSpacing12,
            const Text('Start typing to search'),
          ],
        ),
      );
    }

    if (query.length < 3) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '💬',
              style: theme.textTheme.headlineMedium,
            ),
            AppSpacingWidgets.verticalSpacing12,
            const Text('Type at least three characters'),
          ],
        ),
      );
    }

    return MovieSearchDataWrapper(
      query: query,
    );
  }
}

class _ClearIcon extends StatelessWidget {
  const _ClearIcon({
    // ignore: unused_element
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.clear),
      tooltip: 'Clear',
      onPressed: onPressed,
    );
  }
}
