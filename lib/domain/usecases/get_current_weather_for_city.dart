import '../entities/city_weather.dart';
import '../exceptions/invalid_city_name_exception.dart';
import '../repositories/weather_repository.dart';

abstract class GetCurrentWeatherForCity {
  Future<CityWeather> call(String cityName);
}

class GetCurrentWeatherForCityImplementation implements GetCurrentWeatherForCity {
  final WeatherRepository repository;

  const GetCurrentWeatherForCityImplementation(this.repository);

  @override
  Future<CityWeather> call(String cityName) async {
    if (cityName.isEmpty) throw const InvalidCityNameException();
    return await repository.getCurrentWeatherForCity(cityName);
  }
}
