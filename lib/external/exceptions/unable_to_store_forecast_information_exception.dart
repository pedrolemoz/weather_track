class UnableToStoreForecastInformationException implements Exception {
  final String reason;

  const UnableToStoreForecastInformationException(this.reason);

  @override
  String toString() => 'Unable to store forecast information. Reason: $reason';
}
