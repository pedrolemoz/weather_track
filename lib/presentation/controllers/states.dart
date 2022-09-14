abstract class AppState {}

abstract class SuccessState extends AppState {}

abstract class ErrorState extends AppState {
  final String reason;

  ErrorState(this.reason);
}

abstract class ProcessingState extends AppState {}

class InitialState implements AppState {}

class NoInternetConnectionState implements ErrorState {
  @override
  final String reason;

  NoInternetConnectionState(this.reason);
}

class UnableToGetForecastState implements ErrorState {
  @override
  final String reason;

  UnableToGetForecastState(this.reason);
}

class UnableToGetCurrentWeatherState implements ErrorState {
  @override
  final String reason;

  UnableToGetCurrentWeatherState(this.reason);
}

class UnableToStoreForecastState implements ErrorState {
  @override
  final String reason;

  UnableToStoreForecastState(this.reason);
}

class NoForecastInformationState implements ErrorState {
  @override
  final String reason;

  NoForecastInformationState(this.reason);
}

class NoCityWeatherInformationState implements ErrorState {
  @override
  final String reason;

  NoCityWeatherInformationState(this.reason);
}

class InvalidCityNameState implements ErrorState {
  @override
  final String reason;

  InvalidCityNameState(this.reason);
}

class UnknownErrorState implements ErrorState {
  @override
  final String reason;

  UnknownErrorState(this.reason);
}

class GettingCitiesForecastState implements ProcessingState {}

class SuccessfullyGotCitiesForecastState implements SuccessState {}

class GettingCurrentWeatherForCityState implements ProcessingState {}

class SuccessfullyGotCurrentWeatherForCityState implements SuccessState {}
