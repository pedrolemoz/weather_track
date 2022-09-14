class UnableToGetForecastInformationException implements Exception {
  final String reason;

  const UnableToGetForecastInformationException(this.reason);

  @override
  String toString() => 'Unable to get forecast information. Reason: $reason';
}
