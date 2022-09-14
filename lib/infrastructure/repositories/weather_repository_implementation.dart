import '../../domain/entities/city_weather.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../utils/network_connection_verifier/exceptions/no_internet_connection_exception.dart';
import '../../utils/network_connection_verifier/network_connection_verifier.dart';
import '../datasources/weather_api.dart';
import '../datasources/weather_local_cache.dart';

class WeatherRepositoryImplementation implements WeatherRepository {
  final NetworkConnectionVerifier networkVerifier;
  final WeatherAPI weatherAPI;
  final WeatherLocalCache weatherLocalCache;

  const WeatherRepositoryImplementation(this.networkVerifier, this.weatherAPI, this.weatherLocalCache);

  @override
  Future<Forecast> getForecastForCity(String cityName) async {
    if (await networkVerifier.hasActiveInternetConnection) {
      final forecast = await weatherAPI.getForecastForCity(cityName);
      await weatherLocalCache.storeCityForecast(forecast);
      return forecast;
    }

    try {
      return await weatherLocalCache.getForecastForCity(cityName);
    } catch (exception) {
      throw const NoInternetConnectionException();
    }
  }

  @override
  Future<CityWeather> getCurrentWeatherForCity(String cityName) async {
    if (await networkVerifier.hasActiveInternetConnection) {
      return await weatherAPI.getCurrentWeatherForCity(cityName);
    }

    throw const NoInternetConnectionException();
  }
}
