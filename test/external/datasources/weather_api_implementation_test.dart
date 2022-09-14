import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_track/domain/entities/city_weather.dart';
import 'package:weather_track/domain/entities/forecast.dart';
import 'package:weather_track/external/datasources/weather_api_implementation.dart';
import 'package:weather_track/external/exceptions/no_city_weather_information_found_exception.dart';
import 'package:weather_track/external/exceptions/no_forecast_information_found_exception.dart';
import 'package:weather_track/external/exceptions/unable_to_get_city_weather_information_exception.dart';
import 'package:weather_track/external/exceptions/unable_to_get_forecast_information_exception.dart';
import 'package:weather_track/infrastructure/datasources/weather_api.dart';
import 'package:weather_track/utils/datetime/calculate_time_from_epoch.dart';
import 'package:weather_track/utils/http_client/abstraction/http_client.dart';
import 'package:weather_track/utils/http_client/entities/http_response.dart';
import 'package:weather_track/utils/routes/api_routes.dart';

import '../../test_utils/mock_parser.dart';
import '../../test_utils/mocks_paths.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late WeatherAPI weatherAPI;
  late HttpClient httpClientSpy;

  setUp(() {
    httpClientSpy = HttpClientSpy();
    weatherAPI = WeatherAPIImplementation(httpClientSpy);
  });

  test('API should respect abstraction', () {
    expect(weatherAPI, isA<WeatherAPI>());
  });

  group('Forecast for city', () {
    test('Should call the correct API route, get the data, parse it to a Forecast and return it', () async {
      final tDataFromAPI = MockParser.parseJSON(MocksPaths.forecastMock);
      final tDecodedDataFromAPI = json.decode(tDataFromAPI);
      const tCityName = 'São Paulo';
      final tURL = APIRoutes.getForecastForCity(tCityName);
      final tHttpResponse = HttpResponse(tDataFromAPI, 200);

      when(() => httpClientSpy.get(tURL)).thenAnswer((_) async => tHttpResponse);

      final result = await weatherAPI.getForecastForCity(tCityName);

      expect(
        result,
        isA<Forecast>()
            .having(
              (forecast) => forecast.cityName,
              'Parsed city name correctly',
              tDecodedDataFromAPI['city']['name'],
            )
            .having(
              (forecast) => forecast.countryName,
              'Parsed country correctly',
              tDecodedDataFromAPI['city']['country'],
            )
            .having(
              (forecast) => forecast.weatherInformation.first.date.toIso8601String(),
              'Parsed date correctly',
              DateTime.parse(tDecodedDataFromAPI['list'][0]['dt_txt']).toIso8601String(),
            )
            .having(
              (forecast) => forecast.weatherInformation.first.description,
              'Parsed description correctly',
              tDecodedDataFromAPI['list'][0]['weather'][0]['description'],
            )
            .having(
              (forecast) => forecast.weatherInformation.first.temperature,
              'Parsed temperature correctly',
              tDecodedDataFromAPI['list'][0]['main']['temp'],
            ),
      );
      verify(() => httpClientSpy.get(tURL));
      verifyNoMoreInteractions(httpClientSpy);
    });

    test('Should throw NoForecastInformationFoundException when the status code is other than 200', () async {
      const tDataFromAPI = '';
      const tCityName = 'Fortaleza';
      final tURL = APIRoutes.getForecastForCity(tCityName);
      const tHttpResponse = HttpResponse(tDataFromAPI, 404);

      when(() => httpClientSpy.get(tURL)).thenAnswer((_) async => tHttpResponse);

      await expectLater(
        () => weatherAPI.getForecastForCity(tCityName),
        throwsA(isA<NoForecastInformationFoundException>()),
      );
      verify(() => httpClientSpy.get(tURL));
      verifyNoMoreInteractions(httpClientSpy);
    });

    test('Should throw NoForecastInformationFoundException if the weather information is empty', () async {
      final tDataFromAPI = MockParser.parseJSON(MocksPaths.forecastMock);
      final tDecodedDataFromAPI = json.decode(tDataFromAPI);
      tDecodedDataFromAPI['list'] = [];
      final tModifiedData = json.encode(tDecodedDataFromAPI);
      const tCityName = 'Fortaleza';
      final tURL = APIRoutes.getForecastForCity(tCityName);
      final tHttpResponse = HttpResponse(tModifiedData, 200);

      when(() => httpClientSpy.get(tURL)).thenAnswer((_) async => tHttpResponse);

      await expectLater(
        () => weatherAPI.getForecastForCity(tCityName),
        throwsA(isA<NoForecastInformationFoundException>()),
      );
      verify(() => httpClientSpy.get(tURL));
      verifyNoMoreInteractions(httpClientSpy);
    });
    test('Should throw UnableToGetForecastInformationException when an unexpected exception occurs', () async {
      final tException = Exception('Unexpected error!');
      const tCityName = 'Fortaleza';
      final tURL = APIRoutes.getForecastForCity(tCityName);

      when(() => httpClientSpy.get(tURL)).thenThrow(tException);

      await expectLater(
        () => weatherAPI.getForecastForCity(tCityName),
        throwsA(
          isA<UnableToGetForecastInformationException>().having(
            (exception) => exception.reason,
            'Has the cause of exception',
            tException.toString(),
          ),
        ),
      );
      verify(() => httpClientSpy.get(tURL));
      verifyNoMoreInteractions(httpClientSpy);
    });
  });
  group('Current weather for city', () {
    test('Should call the correct API route, get the data, parse it to a CityWeather and return it', () async {
      final tDataFromAPI = MockParser.parseJSON(MocksPaths.currentWeatherMock);
      final tDecodedDataFromAPI = json.decode(tDataFromAPI);
      const tCityName = 'São Paulo';
      final tURL = APIRoutes.getCurrentWeatherForCity(tCityName);
      final tHttpResponse = HttpResponse(tDataFromAPI, 200);

      when(() => httpClientSpy.get(tURL)).thenAnswer((_) async => tHttpResponse);

      final result = await weatherAPI.getCurrentWeatherForCity(tCityName);

      expect(
        result,
        isA<CityWeather>()
            .having(
              (weather) => weather.cityName,
              'Parsed city name correctly',
              tDecodedDataFromAPI['name'],
            )
            .having(
              (weather) => weather.countryName,
              'Parsed country correctly',
              tDecodedDataFromAPI['sys']['country'],
            )
            .having(
              (weather) => weather.weatherInformation.date.toIso8601String(),
              'Parsed country correctly',
              calculateTimeFromEpoch(tDecodedDataFromAPI['dt']).toIso8601String(),
            )
            .having(
              (weather) => weather.weatherInformation.temperature,
              'Parsed temperature correctly',
              tDecodedDataFromAPI['main']['temp'],
            )
            .having(
              (weather) => weather.weatherInformation.description,
              'Parsed description correctly',
              tDecodedDataFromAPI['weather'][0]['description'],
            ),
      );
      verify(() => httpClientSpy.get(tURL));
      verifyNoMoreInteractions(httpClientSpy);
    });

    test('Should throw NoCityWeatherInformationFoundException when the status code is other than 200', () async {
      const tDataFromAPI = '';
      const tCityName = 'São Paulo';
      final tURL = APIRoutes.getCurrentWeatherForCity(tCityName);
      const tHttpResponse = HttpResponse(tDataFromAPI, 404);

      when(() => httpClientSpy.get(tURL)).thenAnswer((_) async => tHttpResponse);

      await expectLater(
        () => weatherAPI.getCurrentWeatherForCity(tCityName),
        throwsA(isA<NoCityWeatherInformationFoundException>()),
      );
      verify(() => httpClientSpy.get(tURL));
      verifyNoMoreInteractions(httpClientSpy);
    });

    test('Should throw UnableToGetCityWeatherInformationException when an unexpected exception occurs', () async {
      final tException = Exception('Unexpected error!');
      const tCityName = 'São Paulo';
      final tURL = APIRoutes.getCurrentWeatherForCity(tCityName);

      when(() => httpClientSpy.get(tURL)).thenThrow(tException);

      await expectLater(
        () => weatherAPI.getCurrentWeatherForCity(tCityName),
        throwsA(
          isA<UnableToGetCityWeatherInformationException>().having(
            (exception) => exception.reason,
            'Has the cause of exception',
            tException.toString(),
          ),
        ),
      );
      verify(() => httpClientSpy.get(tURL));
      verifyNoMoreInteractions(httpClientSpy);
    });
  });
}
