import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class MovieDetailScore extends StatelessWidget {
  const MovieDetailScore({
    super.key,
    required this.score,
  });
  final double score;

  static const double _strokeWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);

    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppConstants.primaryColor,
      ),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          Padding(
            padding: AppConstants.padding8,
            child: SizedBox(
              key: ValueKey(_circleProgress),
              width: _calculateCircleSize(
                textScaleFactor,
              ),
              height: _calculateCircleSize(
                textScaleFactor,
              ),
              child: CircularProgressIndicator(
                value: _circleProgress,
                strokeWidth: _strokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _strokeColor,
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: AppConstants.padding8,
              child: Text(
                '$_percentage%',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color get _strokeColor {
    if (score >= 7) {
      return const Color(0xFF00BE69);
    }
    if (score >= 5) {
      return Colors.yellow;
    }
    return Colors.red;
  }

  double _calculateCircleSize(double textScaleFactor) {
    return textScaleFactor * 40.0;
  }

  String get _percentage => (score * 10).toStringAsFixed(0);

  double get _circleProgress => score / 10;
}
