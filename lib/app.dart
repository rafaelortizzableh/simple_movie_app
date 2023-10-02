import 'package:flutter/material.dart';

import 'core/core.dart';

class SimpleMovieApp extends StatelessWidget {
  const SimpleMovieApp({super.key});

  static const _appName = 'Simple Movie App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: AppConstants.primaryColor,
        ),
      ),
      onGenerateRoute: AppRouter.generateMaterialPageRoute,
    );
  }
}
