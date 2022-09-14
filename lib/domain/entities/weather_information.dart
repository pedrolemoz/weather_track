class WeatherInformation {
  final double temperature;
  final DateTime date;
  final String description;

  const WeatherInformation({required this.temperature, required this.date, required this.description});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeatherInformation &&
        other.temperature == temperature &&
        other.date == date &&
        other.description == description;
  }

  @override
  int get hashCode => temperature.hashCode ^ date.hashCode ^ description.hashCode;
}
