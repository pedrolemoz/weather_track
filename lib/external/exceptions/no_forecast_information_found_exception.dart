class NoForecastInformationFoundException implements Exception {
  const NoForecastInformationFoundException();

  @override
  String toString() => 'No forecast information found';
}
