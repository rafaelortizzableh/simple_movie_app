import 'package:flutter/material.dart';

import '../core.dart';

class FadingNetworkImage extends StatelessWidget {
  const FadingNetworkImage({
    super.key,
    required this.path,
    this.animationDuration = const Duration(seconds: 1),
  });

  final String path;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      path,
      fit: BoxFit.cover,
      frameBuilder: (
        BuildContext context,
        Widget child,
        int? frame,
        bool wasSynchronouslyLoaded,
      ) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          opacity: _calculateOpacity(frame),
          duration: animationDuration,
          curve: Curves.easeOut,
          child: child,
        );
      },
      errorBuilder: (context, e, s) {
        return AppSpacingWidgets.emptySpace;
      },
    );
  }

  double _calculateOpacity(int? frame) {
    return frame == null ? 0.0 : 1.0;
  }
}
