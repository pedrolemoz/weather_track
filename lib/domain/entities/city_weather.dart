import 'weather_information.dart';

class CityWeather {
  final String cityName;
  final String countryName;
  final WeatherInformation weatherInformation;

  const CityWeather({required this.cityName, required this.countryName, required this.weatherInformation});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CityWeather &&
        other.cityName == cityName &&
        other.countryName == countryName &&
        other.weatherInformation == weatherInformation;
  }

  @override
  int get hashCode => cityName.hashCode ^ countryName.hashCode ^ weatherInformation.hashCode;
}
