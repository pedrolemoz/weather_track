import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_track/domain/entities/city_weather.dart';
import 'package:weather_track/domain/entities/forecast.dart';
import 'package:weather_track/domain/entities/weather_information.dart';
import 'package:weather_track/domain/repositories/weather_repository.dart';
import 'package:weather_track/external/exceptions/no_forecast_information_found_exception.dart';
import 'package:weather_track/infrastructure/datasources/weather_api.dart';
import 'package:weather_track/infrastructure/datasources/weather_local_cache.dart';
import 'package:weather_track/infrastructure/repositories/weather_repository_implementation.dart';
import 'package:weather_track/utils/network_connection_verifier/exceptions/no_internet_connection_exception.dart';
import 'package:weather_track/utils/network_connection_verifier/network_connection_verifier.dart';

class WeatherAPISpy extends Mock implements WeatherAPI {}

class WeatherLocalCacheSpy extends Mock implements WeatherLocalCache {}

class NetworkConnectionVerifierSpy extends Mock implements NetworkConnectionVerifier {}

void main() {
  late WeatherRepository repository;
  late WeatherAPI weatherAPISpy;
  late WeatherLocalCache weatherLocalCacheSpy;
  late NetworkConnectionVerifier networkConnectionVerifierSpy;

  setUp(() {
    weatherAPISpy = WeatherAPISpy();
    weatherLocalCacheSpy = WeatherLocalCacheSpy();
    networkConnectionVerifierSpy = NetworkConnectionVerifierSpy();
    repository = WeatherRepositoryImplementation(
      networkConnectionVerifierSpy,
      weatherAPISpy,
      weatherLocalCacheSpy,
    );
  });

  test('Repository should respect abstraction', () {
    expect(repository, isA<WeatherRepository>());
  });

  group('Forecast for city', () {
    test('Should return a Forecast using API when the device is online, and store the forecast in cache', () async {
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

      when(() => networkConnectionVerifierSpy.hasActiveInternetConnection).thenAnswer((_) async => true);
      when(() => weatherAPISpy.getForecastForCity(tCityName)).thenAnswer((_) async => tForecast);
      when(() => weatherLocalCacheSpy.storeCityForecast(tForecast)).thenAnswer((_) async => Future.value());

      final result = await repository.getForecastForCity(tCityName);

      expect(
        result,
        isA<Forecast>().having(
          (forecast) => forecast,
          'Has the same entity',
          tForecast,
        ),
      );
      verifyInOrder([
        () => networkConnectionVerifierSpy.hasActiveInternetConnection,
        () => weatherAPISpy.getForecastForCity(tCityName),
        () => weatherLocalCacheSpy.storeCityForecast(tForecast),
      ]);
      verifyNoMoreInteractions(networkConnectionVerifierSpy);
      verifyNoMoreInteractions(weatherAPISpy);
      verifyNoMoreInteractions(weatherLocalCacheSpy);
    });

    test('Should return a Forecast using local cache when the device is offline and has stored data', () async {
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

      when(() => networkConnectionVerifierSpy.hasActiveInternetConnection).thenAnswer((_) async => false);
      when(() => weatherLocalCacheSpy.getForecastForCity(tCityName)).thenAnswer((_) async => tForecast);

      final result = await repository.getForecastForCity(tCityName);

      expect(
        result,
        isA<Forecast>().having(
          (forecast) => forecast,
          'Has the same entity',
          tForecast,
        ),
      );
      verifyInOrder([
        () => networkConnectionVerifierSpy.hasActiveInternetConnection,
        () => weatherLocalCacheSpy.getForecastForCity(tCityName),
      ]);
      verifyNoMoreInteractions(networkConnectionVerifierSpy);
      verifyNoMoreInteractions(weatherLocalCacheSpy);
      verifyZeroInteractions(weatherAPISpy);
    });

    test('Should throw NoInternetConnectionException when device is offline and has no stored data', () async {
      final tCityName = faker.address.city();

      when(() => networkConnectionVerifierSpy.hasActiveInternetConnection).thenAnswer((_) async => false);
      when(() => weatherLocalCacheSpy.getForecastForCity(tCityName))
          .thenThrow(const NoForecastInformationFoundException());

      await expectLater(
        () => repository.getForecastForCity(tCityName),
        throwsA(isA<NoInternetConnectionException>()),
      );
      verifyInOrder([
        () => networkConnectionVerifierSpy.hasActiveInternetConnection,
        () => weatherLocalCacheSpy.getForecastForCity(tCityName),
      ]);
      verifyNoMoreInteractions(networkConnectionVerifierSpy);
      verifyNoMoreInteractions(weatherLocalCacheSpy);
      verifyZeroInteractions(weatherAPISpy);
    });
  });
  group('Current weather for city', () {
    test('Should return a CityWeather using API when the device is online', () async {
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

      when(() => networkConnectionVerifierSpy.hasActiveInternetConnection).thenAnswer((_) async => true);
      when(() => weatherAPISpy.getCurrentWeatherForCity(tCityName)).thenAnswer((_) async => tCityWeather);

      final result = await repository.getCurrentWeatherForCity(tCityName);

      expect(
        result,
        isA<CityWeather>().having(
          (weather) => weather,
          'Has the same entity',
          tCityWeather,
        ),
      );
      verifyInOrder([
        () => networkConnectionVerifierSpy.hasActiveInternetConnection,
        () => weatherAPISpy.getCurrentWeatherForCity(tCityName),
      ]);
      verifyNoMoreInteractions(networkConnectionVerifierSpy);
      verifyNoMoreInteractions(weatherAPISpy);
      verifyZeroInteractions(weatherLocalCacheSpy);
    });

    test('Should throw NoInternetConnectionException when device is offline', () async {
      final tCityName = faker.address.city();

      when(() => networkConnectionVerifierSpy.hasActiveInternetConnection).thenAnswer((_) async => false);

      await expectLater(
        () => repository.getCurrentWeatherForCity(tCityName),
        throwsA(isA<NoInternetConnectionException>()),
      );
      verify(() => networkConnectionVerifierSpy.hasActiveInternetConnection);
      verifyNoMoreInteractions(networkConnectionVerifierSpy);
      verifyZeroInteractions(weatherLocalCacheSpy);
      verifyZeroInteractions(weatherAPISpy);
    });
  });
}
