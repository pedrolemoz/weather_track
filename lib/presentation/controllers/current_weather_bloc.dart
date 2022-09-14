import 'package:bloc/bloc.dart';

import '../../domain/entities/city_weather.dart';
import '../../domain/exceptions/invalid_city_name_exception.dart';
import '../../domain/usecases/get_current_weather_for_city.dart';
import '../../external/exceptions/no_city_weather_information_found_exception.dart';
import '../../external/exceptions/unable_to_get_city_weather_information_exception.dart';
import '../../utils/network_connection_verifier/exceptions/no_internet_connection_exception.dart';
import 'events.dart';
import 'states.dart';

class CurrentWeatherBloc extends Bloc<WeatherEvent, AppState> {
  final GetCurrentWeatherForCity _getCurrentWeatherForCity;

  CityWeather? cityWeather;

  CurrentWeatherBloc(this._getCurrentWeatherForCity) : super(InitialState()) {
    on<GetCurrentWeatherForCityEvent>(_onGetCurrentWeatherForCityEvent);
  }

  Future<void> _onGetCurrentWeatherForCityEvent(
    GetCurrentWeatherForCityEvent event,
    Emitter<AppState> emitter,
  ) async {
    emitter(GettingCurrentWeatherForCityState());

    try {
      cityWeather = await _getCurrentWeatherForCity(event.city);
      emitter(SuccessfullyGotCurrentWeatherForCityState());
    } on InvalidCityNameException catch (exception) {
      emitter(InvalidCityNameState(exception.toString()));
    } on NoCityWeatherInformationFoundException catch (exception) {
      emitter(NoCityWeatherInformationState(exception.toString()));
    } on UnableToGetCityWeatherInformationException catch (exception) {
      emitter(UnableToGetCurrentWeatherState(exception.toString()));
    } on NoInternetConnectionException catch (exception) {
      emitter(NoInternetConnectionState(exception.toString()));
    } catch (exception) {
      emitter(UnknownErrorState(exception.toString()));
    }
  }
}
