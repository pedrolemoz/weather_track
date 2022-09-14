import '../../domain/entities/city_weather.dart';
import '../../domain/entities/forecast.dart';

abstract class WeatherAPI {
  Future<Forecast> getForecastForCity(String cityName);
  Future<CityWeather> getCurrentWeatherForCity(String cityName);
}
