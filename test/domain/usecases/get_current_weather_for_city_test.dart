import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_track/domain/entities/city_weather.dart';
import 'package:weather_track/domain/entities/weather_information.dart';
import 'package:weather_track/domain/exceptions/invalid_city_name_exception.dart';
import 'package:weather_track/domain/repositories/weather_repository.dart';
import 'package:weather_track/domain/usecases/get_current_weather_for_city.dart';

class WeatherRepositorySpy extends Mock implements WeatherRepository {}

void main() {
  late GetCurrentWeatherForCity usecase;
  late WeatherRepository repositorySpy;

  setUp(() {
    repositorySpy = WeatherRepositorySpy();
    usecase = GetCurrentWeatherForCityImplementation(repositorySpy);
  });

  test('Usecase should respect abstraction', () {
    expect(usecase, isA<GetCurrentWeatherForCity>());
  });

  test('Should return a CityWeather in the success case', () async {
    final tCityWeather = CityWeather(
      cityName: faker.address.city(),
      countryName: faker.address.country(),
      weatherInformation: WeatherInformation(
        temperature: faker.randomGenerator.decimal(min: -50),
        date: DateTime.now(),
        description: faker.lorem.sentence(),
      ),
    );

    final tCityName = faker.address.city();

    when(() => repositorySpy.getCurrentWeatherForCity(tCityName)).thenAnswer((_) async => tCityWeather);

    final result = await usecase(tCityName);

    expect(
      result,
      isA<CityWeather>().having(
        (weather) => weather,
        'Has the same entity',
        tCityWeather,
      ),
    );
    verify(() => repositorySpy.getCurrentWeatherForCity(tCityName));
    verifyNoMoreInteractions(repositorySpy);
  });

  test('Should throw InvalidCityNameException if the city name is empty', () async {
    const tCityName = '';

    await expectLater(() => usecase(tCityName), throwsA(isA<InvalidCityNameException>()));
    verifyZeroInteractions(repositorySpy);
  });
}
