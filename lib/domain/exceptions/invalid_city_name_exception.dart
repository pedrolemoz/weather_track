class InvalidCityNameException implements Exception {
  const InvalidCityNameException();

  @override
  String toString() => 'City name should not be empty';
}
