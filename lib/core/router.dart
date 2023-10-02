import 'package:flutter/material.dart';

import '../../../features/features.dart';
import 'core.dart';

abstract class AppRouter {
  static Route<MaterialPageRoute> generateMaterialPageRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case MoviesPage.routeName:
        return MaterialPageRoute(
          builder: (context) => const MoviesPage(),
          settings: settings,
        );
      case MovieDetailPage.routeName:
        return MaterialPageRoute(builder: (context) {
          final args = settings.arguments;
          if (args is Movie) {
            return MovieDetailPage(movie: args);
          }
          return UnknownRouteScreen(settings: settings);
        });

      default:
        return MaterialPageRoute(
          builder: (context) => UnknownRouteScreen(settings: settings),
          settings: settings,
        );
    }
  }
}
