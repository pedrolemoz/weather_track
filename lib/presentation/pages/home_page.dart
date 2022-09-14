import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/entities/city_weather.dart';
import '../../domain/usecases/get_current_weather_for_city.dart';
import '../../utils/task/main_cities.dart';
import '../controllers/events.dart';
import '../controllers/forecast_bloc.dart';
import '../controllers/states.dart';
import '../delegates/city_weather_search_delegate.dart';
import '../widgets/forecast_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final forecastBloc = Modular.get<ForecastBloc>();
  final usecase = Modular.get<GetCurrentWeatherForCity>();

  @override
  void initState() {
    super.initState();
    forecastBloc.add(GetForecastForCitiesEvent(MainCities.cities));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Track'),
        actions: [
          IconButton(
            splashRadius: 22,
            onPressed: () => showSearch<CityWeather?>(context: context, delegate: CityWeatherSearchDelegate()),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: BlocBuilder<ForecastBloc, AppState>(
        bloc: forecastBloc,
        builder: (context, state) {
          if (state is InitialState || state is ProcessingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.reason, style: Theme.of(context).textTheme.headline6),
                  if (state is! UnknownErrorState && state is! InvalidCityNameState) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => forecastBloc.add(GetForecastForCitiesEvent(MainCities.cities)),
                      child: const Text('Try again'),
                    )
                  ]
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => forecastBloc.add(GetForecastForCitiesEvent(MainCities.cities)),
            child: ListView.builder(
              itemCount: forecastBloc.forecasts.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final forecast = forecastBloc.forecasts.elementAt(index);
                return ForecastCard(forecast: forecast);
              },
            ),
          );
        },
      ),
    );
  }
}
