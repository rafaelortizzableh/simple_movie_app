import 'package:flutter/material.dart';

import '../../features/features.dart';

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({
    super.key,
    required this.settings,
  });
  final RouteSettings? settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('404: Not found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Error finding ${settings?.name}'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MoviesPage.routeName,
                  (route) => false,
                );
              },
              child: const Text('Home'),
            ),
          ],
        ),
      ),
    );
  }
}
