import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class GenericError extends StatelessWidget {
  const GenericError({
    super.key,
    required this.errorText,
    required this.onRetry,
  });

  final String errorText;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: AppConstants.horizontalPadding12,
            child: Text(
              errorText,
              textAlign: TextAlign.center,
            ),
          ),
          AppSpacingWidgets.verticalSpacing12,
          AdaptiveButton.fromIconData(
            Icons.refresh,
            onPressed: onRetry,
            isLoading: false,
            isDisabled: false,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            child: Text(
              'Retry',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
