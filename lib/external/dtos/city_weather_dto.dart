import 'dart:convert';

import '../../domain/entities/city_weather.dart';
import 'weather_information_dto.dart';

class CityWeatherDTO extends CityWeather {
  const CityWeatherDTO({required super.cityName, required super.countryName, required super.weatherInformation});

  factory CityWeatherDTO.fromMap(Map<String, dynamic> map) => CityWeatherDTO(
        cityName: map['name'],
        countryName: map['sys']['country'],
        weatherInformation: WeatherInformationDTO.fromMap(map),
      );

  factory CityWeatherDTO.fromEntity(CityWeather forecast) {
    return CityWeatherDTO(
      cityName: forecast.cityName,
      countryName: forecast.countryName,
      weatherInformation: WeatherInformationDTO.fromEntity(forecast.weatherInformation),
    );
  }

  factory CityWeatherDTO.fromJSON(String source) => CityWeatherDTO.fromMap(json.decode(source));
}
