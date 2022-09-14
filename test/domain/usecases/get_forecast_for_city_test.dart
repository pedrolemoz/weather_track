import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_track/domain/entities/forecast.dart';
import 'package:weather_track/domain/entities/weather_information.dart';
import 'package:weather_track/domain/exceptions/invalid_city_name_exception.dart';
import 'package:weather_track/domain/repositories/weather_repository.dart';
import 'package:weather_track/domain/usecases/get_forecast_for_city.dart';

class WeatherRepositorySpy extends Mock implements WeatherRepository {}

void main() {
  late GetForecastForCity usecase;
  late WeatherRepository repositorySpy;

  setUp(() {
    repositorySpy = WeatherRepositorySpy();
    usecase = GetForecastForCityImplementation(repositorySpy);
  });

  test('Usecase should respect abstraction', () {
    expect(usecase, isA<GetForecastForCity>());
  });

  test('Should return a Forecast in the success case', () async {
    final tForecast = Forecast(
      cityName: faker.address.city(),
      countryName: faker.address.country(),
      weatherInformation: List.generate(
        10,
        (_) => WeatherInformation(
          temperature: faker.randomGenerator.decimal(min: -50),
          date: DateTime.now(),
          description: faker.lorem.sentence(),
        ),
      ),
    );

    final tCityName = faker.address.city();

    when(() => repositorySpy.getForecastForCity(tCityName)).thenAnswer((_) async => tForecast);

    final result = await usecase(tCityName);

    expect(
      result,
      isA<Forecast>().having(
        (forecast) => forecast,
        'Has the same entity',
        tForecast,
      ),
    );
    verify(() => repositorySpy.getForecastForCity(tCityName));
    verifyNoMoreInteractions(repositorySpy);
  });

  test('Should throw InvalidCityNameException if the city name is empty', () async {
    const tCityName = '';

    await expectLater(() => usecase(tCityName), throwsA(isA<InvalidCityNameException>()));
    verifyZeroInteractions(repositorySpy);
  });
}
