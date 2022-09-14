import '../entities/forecast.dart';
import '../exceptions/invalid_city_name_exception.dart';
import '../repositories/weather_repository.dart';

abstract class GetForecastForCity {
  Future<Forecast> call(String cityName);
}

class GetForecastForCityImplementation implements GetForecastForCity {
  final WeatherRepository repository;

  const GetForecastForCityImplementation(this.repository);

  @override
  Future<Forecast> call(String cityName) async {
    if (cityName.isEmpty) throw const InvalidCityNameException();
    return await repository.getForecastForCity(cityName);
  }
}
