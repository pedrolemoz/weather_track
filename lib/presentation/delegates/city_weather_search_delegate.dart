import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/entities/city_weather.dart';
import '../../utils/formatting/datetime_formatting.dart';
import '../../utils/formatting/weather_formatting.dart';
import '../../utils/task/suggested_cities.dart';
import '../controllers/current_weather_bloc.dart';
import '../controllers/events.dart';
import '../controllers/states.dart';

class CityWeatherSearchDelegate extends SearchDelegate<CityWeather?> {
  final currentWeatherBloc = Modular.get<CurrentWeatherBloc>();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        splashRadius: 22,
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      splashRadius: 22,
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    currentWeatherBloc.add(GetCurrentWeatherForCityEvent(query));

    return BlocBuilder<CurrentWeatherBloc, AppState>(
      bloc: currentWeatherBloc,
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
                    onPressed: () => currentWeatherBloc.add(GetCurrentWeatherForCityEvent(query)),
                    child: const Text('Try again'),
                  )
                ]
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => currentWeatherBloc.add(GetCurrentWeatherForCityEvent(query)),
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${currentWeatherBloc.cityWeather!.cityName}, ${currentWeatherBloc.cityWeather!.countryName}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    currentWeatherBloc.cityWeather!.weatherInformation.formattedTemperature,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                currentWeatherBloc.cityWeather!.weatherInformation.description,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16),
              Text(
                '${currentWeatherBloc.cityWeather!.weatherInformation.date.asWeekDay}, ${currentWeatherBloc.cityWeather!.weatherInformation.date.asDayMonthYear}, ${currentWeatherBloc.cityWeather!.weatherInformation.date.timeAs24Hours}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = suggestedCities.where((name) => name.toLowerCase().contains(query.toLowerCase()));
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final data = suggestions.elementAt(index);
        return ListTile(
          onTap: () {
            query = data;
            showResults(context);
          },
          title: Text(data),
        );
      },
    );
  }
}
