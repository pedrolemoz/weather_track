import 'dart:convert';

import '../../domain/entities/forecast.dart';
import '../../domain/entities/weather_information.dart';
import 'weather_information_dto.dart';

class ForecastDTO extends Forecast {
  const ForecastDTO({required super.cityName, required super.countryName, required super.weatherInformation});

  Map<String, dynamic> toMap() => {
        'city': {'name': cityName, 'country': countryName},
        'list': weatherInformation.map((weather) => (weather as WeatherInformationDTO).toMap()).toList(),
      };

  factory ForecastDTO.fromMap(Map<String, dynamic> map) => ForecastDTO(
        cityName: map['city']['name'],
        countryName: map['city']['country'],
        weatherInformation:
            List<WeatherInformation>.from(map['list'].map((weather) => WeatherInformationDTO.fromMap(weather))),
      );

  factory ForecastDTO.fromEntity(Forecast forecast) {
    return ForecastDTO(
      cityName: forecast.cityName,
      countryName: forecast.countryName,
      weatherInformation:
          forecast.weatherInformation.map((weather) => WeatherInformationDTO.fromEntity(weather)).toList(),
    );
  }

  String toJSON() => json.encode(toMap());

  factory ForecastDTO.fromJSON(String source) => ForecastDTO.fromMap(json.decode(source));
}
