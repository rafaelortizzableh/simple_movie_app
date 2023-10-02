import '../../../core/core.dart';

class MovieFailure implements Failure {
  MovieFailure({
    required this.type,
  });

  final MovieFailureType type;

  @override
  String get message => _failureMessages[type.code] ?? 'Unknown error';

  @override
  int? get code => type.code;

  @override
  Exception? get exception => null;

  Map<int, String> get _failureMessages {
    return {
      200: 'Oops! Something went wrong. Please try again later.',
      201:
          'Looks like you are not connected to the internet. Please check your connection and try again.',
      202:
          'Oops! Something went wrong when finding movies. Please try again later.',
      203:
          'Oops! Something went wrong when processing movies. Please try again later.',
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieFailure && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;

  @override
  String toString() => 'MovieFailure(type: $type)';
}

enum MovieFailureType {
  noInternetConnection(201),
  serverError(202),
  serializationError(203),
  unknown(200);

  const MovieFailureType(this.code);

  final int code;
}
