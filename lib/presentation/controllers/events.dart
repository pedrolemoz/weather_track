abstract class WeatherEvent {}

class GetForecastForCitiesEvent implements WeatherEvent {
  final List<String> cities;

  const GetForecastForCitiesEvent(this.cities);
}

class GetCurrentWeatherForCityEvent implements WeatherEvent {
  final String city;

  const GetCurrentWeatherForCityEvent(this.city);
}
