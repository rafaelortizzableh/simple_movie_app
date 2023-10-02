import 'package:flutter/material.dart';

import 'core.dart';

abstract class SimpleMovieAppTheme {
  static ThemeData get lightThemeData {
    final defaultTheme = ThemeData.light();
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
      useMaterial3: false,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: AppConstants.primaryColor,
        titleTextStyle: defaultTheme.textTheme.bodyLarge?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
