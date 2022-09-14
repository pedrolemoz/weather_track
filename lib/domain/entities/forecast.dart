import '../../utils/equality/list_equals.dart';
import 'weather_information.dart';

class Forecast {
  final String cityName;
  final String countryName;
  final List<WeatherInformation> weatherInformation;

  const Forecast({required this.cityName, required this.countryName, required this.weatherInformation});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Forecast &&
        other.cityName == cityName &&
        other.countryName == countryName &&
        listEquals(other.weatherInformation, weatherInformation);
  }

  @override
  int get hashCode => cityName.hashCode ^ countryName.hashCode ^ weatherInformation.hashCode;
}
