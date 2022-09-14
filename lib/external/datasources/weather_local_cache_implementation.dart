import 'dart:convert';

import '../../domain/entities/forecast.dart';
import '../../infrastructure/datasources/weather_local_cache.dart';
import '../../utils/cache/keys/cache_keys.dart';
import '../../utils/cache/local_storage/local_storage_service.dart';
import '../dtos/forecast_dto.dart';
import '../exceptions/no_forecast_information_found_exception.dart';
import '../exceptions/unable_to_get_forecast_information_exception.dart';
import '../exceptions/unable_to_store_forecast_information_exception.dart';

class WeatherLocalCacheImplementation implements WeatherLocalCache {
  final LocalStorageService localStorage;

  const WeatherLocalCacheImplementation(this.localStorage);

  @override
  Future<Forecast> getForecastForCity(String cityName) async {
    try {
      if (!await hasAnyStoredForecast()) throw const NoForecastInformationFoundException();

      final forecastEntryIdentifier = 'forecast_$cityName';
      final Map data = json.decode(await localStorage.getStoredData(key: CacheKeys.forecastCache));

      if (data.containsKey(forecastEntryIdentifier)) {
        final forecastData = data[forecastEntryIdentifier];
        return ForecastDTO.fromMap(forecastData);
      }

      throw const NoForecastInformationFoundException();
    } catch (exception) {
      throw UnableToGetForecastInformationException(exception.toString());
    }
  }

  @override
  Future<bool> hasAnyStoredForecast() async => await localStorage.hasStoredDataInKey(key: CacheKeys.forecastCache);

  @override
  Future<void> storeCityForecast(Forecast forecast) async {
    try {
      final forecastDTO = ForecastDTO.fromEntity(forecast);
      final forecastEntryIdentifier = 'forecast_${forecast.cityName}';
      final entry = {forecastEntryIdentifier: forecastDTO.toMap()};

      if (await hasAnyStoredForecast()) {
        final Map data = json.decode(await localStorage.getStoredData(key: CacheKeys.forecastCache));

        if (data.containsKey(forecastEntryIdentifier)) {
          data.remove(forecastEntryIdentifier);
        }

        data.addAll(entry);

        await localStorage.storeData(key: CacheKeys.forecastCache, value: json.encode(data));
      } else {
        await localStorage.storeData(key: CacheKeys.forecastCache, value: json.encode(entry));
      }
    } catch (exception) {
      throw UnableToStoreForecastInformationException(exception.toString());
    }
  }
}
