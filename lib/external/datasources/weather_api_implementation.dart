import 'dart:io';

import '../../domain/entities/city_weather.dart';
import '../../domain/entities/forecast.dart';
import '../../infrastructure/datasources/weather_api.dart';
import '../../utils/http_client/abstraction/http_client.dart';
import '../../utils/routes/api_routes.dart';
import '../dtos/city_weather_dto.dart';
import '../dtos/forecast_dto.dart';
import '../exceptions/no_city_weather_information_found_exception.dart';
import '../exceptions/no_forecast_information_found_exception.dart';
import '../exceptions/unable_to_get_city_weather_information_exception.dart';
import '../exceptions/unable_to_get_forecast_information_exception.dart';

class WeatherAPIImplementation implements WeatherAPI {
  final HttpClient httpClient;

  const WeatherAPIImplementation(this.httpClient);

  @override
  Future<Forecast> getForecastForCity(String cityName) async {
    final url = APIRoutes.getForecastForCity(cityName);
    try {
      final result = await httpClient.get(url);
      switch (result.statusCode) {
        case HttpStatus.ok:
          final forecast = ForecastDTO.fromJSON(result.data);
          if (forecast.weatherInformation.isEmpty) throw const NoForecastInformationFoundException();
          return forecast;
        default:
          throw const NoForecastInformationFoundException();
      }
    } on NoForecastInformationFoundException {
      rethrow;
    } catch (exception) {
      throw UnableToGetForecastInformationException(exception.toString());
    }
  }

  @override
  Future<CityWeather> getCurrentWeatherForCity(String cityName) async {
    final url = APIRoutes.getCurrentWeatherForCity(cityName);
    try {
      final result = await httpClient.get(url);
      switch (result.statusCode) {
        case HttpStatus.ok:
          return CityWeatherDTO.fromJSON(result.data);
        default:
          throw const NoCityWeatherInformationFoundException();
      }
    } on NoCityWeatherInformationFoundException {
      rethrow;
    } catch (exception) {
      throw UnableToGetCityWeatherInformationException(exception.toString());
    }
  }
}
