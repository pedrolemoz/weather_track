import 'package:bloc/bloc.dart';

import '../../domain/entities/forecast.dart';
import '../../domain/exceptions/invalid_city_name_exception.dart';
import '../../domain/usecases/get_forecast_for_city.dart';
import '../../external/exceptions/no_forecast_information_found_exception.dart';
import '../../external/exceptions/unable_to_get_forecast_information_exception.dart';
import '../../external/exceptions/unable_to_store_forecast_information_exception.dart';
import '../../utils/network_connection_verifier/exceptions/no_internet_connection_exception.dart';
import 'events.dart';
import 'states.dart';

class ForecastBloc extends Bloc<WeatherEvent, AppState> {
  final GetForecastForCity _getForecastForCity;

  List<Forecast> forecasts = [];

  ForecastBloc(this._getForecastForCity) : super(InitialState()) {
    on<GetForecastForCitiesEvent>(_onGetForecastForCitiesEvent);
  }

  Future<void> _onGetForecastForCitiesEvent(
    GetForecastForCitiesEvent event,
    Emitter<AppState> emitter,
  ) async {
    emitter(GettingCitiesForecastState());

    try {
      for (final city in event.cities) {
        final result = await _getForecastForCity(city);
        forecasts.add(result);
      }

      if (forecasts.length != event.cities.length) emitter(UnableToGetForecastState('Could not fetch all data'));

      emitter(SuccessfullyGotCitiesForecastState());
    } on InvalidCityNameException catch (exception) {
      emitter(InvalidCityNameState(exception.toString()));
    } on NoForecastInformationFoundException catch (exception) {
      emitter(NoForecastInformationState(exception.toString()));
    } on UnableToGetForecastInformationException catch (exception) {
      emitter(UnableToGetForecastState(exception.toString()));
    } on UnableToStoreForecastInformationException catch (exception) {
      emitter(UnableToStoreForecastState(exception.toString()));
    } on NoInternetConnectionException catch (exception) {
      emitter(NoInternetConnectionState(exception.toString()));
    } catch (exception) {
      emitter(UnknownErrorState(exception.toString()));
    }
  }
}
