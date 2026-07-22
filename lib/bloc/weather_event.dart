import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class WeatherFetchRequested extends WeatherEvent {
  final String city;
  const WeatherFetchRequested(this.city);

  @override
  List<Object?> get props => [city];
}

class WeatherUnitToggled extends WeatherEvent {
  const WeatherUnitToggled();
}

class WeatherCacheLoadRequested extends WeatherEvent {
  const WeatherCacheLoadRequested();
}

  