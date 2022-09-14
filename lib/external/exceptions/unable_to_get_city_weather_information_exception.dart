class UnableToGetCityWeatherInformationException implements Exception {
  final String reason;

  const UnableToGetCityWeatherInformationException(this.reason);

  @override
  String toString() => 'Unable to get city weather information. Reason: $reason';
}
