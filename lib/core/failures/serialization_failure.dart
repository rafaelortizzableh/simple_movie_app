class SerializationFailure implements Exception {
  const SerializationFailure({
    required this.className,
  });

  final String className;

  @override
  String toString() => 'SerializationException: $className';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SerializationFailure && other.className == className;
  }

  @override
  int get hashCode => className.hashCode;
}
