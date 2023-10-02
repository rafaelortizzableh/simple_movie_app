import 'package:flutter/foundation.dart';

/// An exception thrown when the response is invalid.
class ApiInvalidResponseFailure implements Exception {
  const ApiInvalidResponseFailure({
    required this.statusCode,
    required this.body,
  });

  /// The associated http status code.
  final int statusCode;

  /// The associated response body.
  final Map<String, dynamic> body;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiInvalidResponseFailure &&
        other.statusCode == statusCode &&
        mapEquals(other.body, body);
  }

  @override
  int get hashCode => statusCode.hashCode ^ body.hashCode;
}

/// An exception thrown when an error occurs during a request.
class ApiRequestFailure implements Exception {
  const ApiRequestFailure({
    required this.error,
  });

  /// The associated error.
  final Object error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiRequestFailure && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

/// An Exception thrown when there are timeout issues with the request.
class ApiTimeoutFailure implements Exception {
  const ApiTimeoutFailure({
    required this.error,
  });

  /// The associated error.
  final Object error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiTimeoutFailure && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

/// An Exception thrown when the request is cancelled.
class ApiCancelledFailure implements Exception {
  const ApiCancelledFailure({
    required this.error,
  });

  /// The associated error.
  final Object error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiCancelledFailure && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
