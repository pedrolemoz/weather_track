import '../../domain/entities/forecast.dart';

abstract class WeatherLocalCache {
  Future<Forecast> getForecastForCity(String cityName);
  Future<void> storeCityForecast(Forecast forecast);
  Future<bool> hasAnyStoredForecast();
}
