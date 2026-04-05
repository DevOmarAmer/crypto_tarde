class RateLimitException implements Exception {
  final String message;
  const RateLimitException(
      [this.message = 'Rate limit exceeded. Please wait and try again.']);

  @override
  String toString() => message;
}
