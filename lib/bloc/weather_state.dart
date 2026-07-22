import 'package:equatable/equatable.dart';
import '../models/weather_model.dart';

enum TemperatureUnit { celsius, fahrenheit }

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

/// Nothing fetched yet - shown before the very first search.
class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

/// A network request is in flight.
class WeatherLoadInProgress extends WeatherState {
  const WeatherLoadInProgress();
}

/// Data was fetched (or loaded from cache) successfully.
class WeatherLoadSuccess extends WeatherState {
  final WeatherModel weather;
  final TemperatureUnit unit;
  final bool isFromCache;

  const WeatherLoadSuccess({
    required this.weather,
    required this.unit,
    this.isFromCache = false,
  });

  WeatherLoadSuccess copyWith({
    WeatherModel? weather,
    TemperatureUnit? unit,
    bool? isFromCache,
  }) {
    return WeatherLoadSuccess(
      weather: weather ?? this.weather,
      unit: unit ?? this.unit,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }

  @override
  List<Object?> get props => [weather, unit, isFromCache];
}

/// Fetch failed. If a previously cached result exists, it's attached so
/// the UI can show stale-but-useful data alongside the error message.
class WeatherLoadFailure extends WeatherState {
  final String message;
  final WeatherModel? cachedWeather;
  final TemperatureUnit unit;

  const WeatherLoadFailure(
    this.message, {
    this.cachedWeather,
    this.unit = TemperatureUnit.celsius,
  });

  @override
  List<Object?> get props => [message, cachedWeather, unit];
}
