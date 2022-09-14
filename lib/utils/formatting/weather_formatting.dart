import '../../domain/entities/weather_information.dart';

extension WeatherExtension on WeatherInformation {
  String get formattedTemperature => '${temperature.ceil()} °C';
}
