import '../secrets/api_key.dart';

class APIRoutes {
  static String getForecastForCity(String cityName) =>
      'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&units=metric&appid=$apiKey';
  static String getCurrentWeatherForCity(String cityName) =>
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=$apiKey';
}
