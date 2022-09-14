import 'package:flutter/material.dart';

import '../../domain/entities/forecast.dart';
import '../../utils/formatting/datetime_formatting.dart';
import '../../utils/formatting/weather_formatting.dart';

class ForecastCard extends StatelessWidget {
  const ForecastCard({super.key, required this.forecast});

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${forecast.cityName}, ${forecast.countryName}',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.33,
              child: ListView.separated(
                itemCount: forecast.weatherInformation.length,
                padding: const EdgeInsets.all(8),
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final weather = forecast.weatherInformation.elementAt(index);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${weather.date.asWeekDay}, ${weather.date.asDayMonthYear}, ${weather.date.timeAs24Hours}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            weather.formattedTemperature,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      Text(
                        weather.description,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
