import 'dart:convert';

import '../../domain/entities/weather_information.dart';
import '../../utils/datetime/calculate_time_from_epoch.dart';

class WeatherInformationDTO extends WeatherInformation {
  const WeatherInformationDTO({required super.temperature, required super.date, required super.description});

  Map<String, dynamic> toMap() => {
        'main': {'temp': temperature},
        'dt_txt': date.toIso8601String(),
        'weather': [
          {'description': description}
        ],
      };

  factory WeatherInformationDTO.fromMap(Map<String, dynamic> map) => WeatherInformationDTO(
        temperature: double.parse(map['main']['temp'].toString()),
        date: map.containsKey('dt_txt')
            ? DateTime.parse(map['dt_txt'])
            : calculateTimeFromEpoch(int.parse(map['dt'].toString())),
        description: map['weather'][0]['description'],
      );

  factory WeatherInformationDTO.fromEntity(WeatherInformation weather) =>
      WeatherInformationDTO(temperature: weather.temperature, date: weather.date, description: weather.description);

  String toJSON() => json.encode(toMap());

  factory WeatherInformationDTO.fromJSON(String source) => WeatherInformationDTO.fromMap(json.decode(source));
}
