import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../core/theme/app_theme.dart';
import '../widgets/city_search_field.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/weather_display_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth > 600
                  ? 500.0
                  : constraints.maxWidth;

              return Center(
                child: SizedBox(
                  width: maxWidth,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _HeaderTitle(),
                        const SizedBox(height: 24),
                        BlocBuilder<WeatherBloc, WeatherState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                CitySearchField(
                                  isLoading: state is WeatherLoadInProgress,
                                  onSearch: (city) {
                                    context.read<WeatherBloc>().add(
                                      WeatherFetchRequested(city),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                _buildContent(context, state),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WeatherState state) {
    if (state is WeatherLoadInProgress) {
      return const LoadingView();
    }

    if (state is WeatherLoadSuccess) {
      return WeatherDisplayCard(
        weather: state.weather,
        unit: state.unit,
        isFromCache: state.isFromCache,
        onToggleUnit: () =>
            context.read<WeatherBloc>().add(const WeatherUnitToggled()),
      );
    }

    if (state is WeatherLoadFailure) {
      if (state.cachedWeather != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ErrorView(message: state.message),
            const SizedBox(height: 16),
            WeatherDisplayCard(
              weather: state.cachedWeather!,
              unit: state.unit,
              isFromCache: true,
              onToggleUnit: () =>
                  context.read<WeatherBloc>().add(const WeatherUnitToggled()),
            ),
          ],
        );
      }
      return ErrorView(message: state.message);
    }

    // WeatherInitial - nothing searched yet.
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(Icons.wb_sunny_outlined, size: 64, color: Colors.white70),
          SizedBox(height: 12),
          Text(
            'Search for a city to view the weather',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.cloud, color: Colors.white, size: 28),
        SizedBox(width: 10),
        Text(
          'Weather App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
