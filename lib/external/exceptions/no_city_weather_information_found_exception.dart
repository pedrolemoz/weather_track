class NoCityWeatherInformationFoundException implements Exception {
  const NoCityWeatherInformationFoundException();

  @override
  String toString() => 'No city weather information found';
}
