class CacheException implements Exception {
  final String reason;

  const CacheException(this.reason);

  @override
  String toString() => 'An internal error occurred in storage. Reason: $reason';
}
