import '../entities/city_weather.dart';
import '../entities/forecast.dart';

abstract class WeatherRepository {
  Future<Forecast> getForecastForCity(String cityName);
  Future<CityWeather> getCurrentWeatherForCity(String cityName);
}
