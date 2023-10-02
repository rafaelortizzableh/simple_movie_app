import 'package:flutter/material.dart';

import 'core/core.dart';

class SimpleMovieApp extends StatelessWidget {
  const SimpleMovieApp({super.key});

  static const _appName = 'Simple Movie App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appName,
      theme: SimpleMovieAppTheme.lightThemeData,
      onGenerateRoute: AppRouter.generateMaterialPageRoute,
    );
  }
}
