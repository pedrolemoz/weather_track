import 'package:animations/animations.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:uno/uno.dart';

import '../domain/usecases/get_current_weather_for_city.dart';
import '../domain/usecases/get_forecast_for_city.dart';
import '../external/datasources/weather_api_implementation.dart';
import '../external/datasources/weather_local_cache_implementation.dart';
import '../infrastructure/repositories/weather_repository_implementation.dart';
import '../utils/cache/local_storage/local_storage_service.dart';
import '../utils/http_client/implementation/uno_client_implementation.dart';
import '../utils/network_connection_verifier/implementation/network_connection_verifier_implementation.dart';
import 'controllers/current_weather_bloc.dart';
import 'controllers/forecast_bloc.dart';
import 'pages/home_page.dart';

class RootModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => Connectivity()),
        Bind((i) => NetworkConnectionVerifierImplementation(i())),
        Bind((i) => Uno()),
        Bind((i) => UnoClientImplementation(i())),
        Bind((i) => const LocalStorageServiceImplementation()),
        Bind((i) => WeatherLocalCacheImplementation(i())),
        Bind((i) => WeatherAPIImplementation(i())),
        Bind((i) => WeatherRepositoryImplementation(i(), i(), i())),
        Bind((i) => GetForecastForCityImplementation(i())),
        Bind((i) => GetCurrentWeatherForCityImplementation(i())),
        Bind<Bloc>((i) => ForecastBloc(i()), onDispose: (bloc) => bloc.close()),
        Bind<Bloc>((i) => CurrentWeatherBloc(i()), onDispose: (bloc) => bloc.close()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, __) => const HomePage(),
          transition: TransitionType.custom,
          customTransition: CustomTransition(
            transitionDuration: const Duration(milliseconds: 400),
            transitionBuilder: (context, animation, secondaryAnimation, child) => FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
          ),
        ),
      ];
}
