import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/weather_model.dart';
import '../services/weather_api_service.dart';
import '../services/weather_cache_service.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApiService apiService;
  final WeatherCacheService cacheService;

  TemperatureUnit _unit = TemperatureUnit.celsius;

  WeatherBloc({
    required this.apiService,
    required this.cacheService,
  }) : super(const WeatherInitial()) {
    on<WeatherFetchRequested>(_onFetchRequested);
    on<WeatherUnitToggled>(_onUnitToggled);
    on<WeatherCacheLoadRequested>(_onCacheLoadRequested);
  }

  Future<void> _onFetchRequested(
    WeatherFetchRequested event,
    Emitter<WeatherState> emit,
  ) async {
    final city = event.city.trim();

    if (city.isEmpty) {
      emit(const WeatherLoadFailure('Please enter a city name to search.'));
      return;
    }

    emit(const WeatherLoadInProgress());

    try {
      final json = await apiService.fetchCurrentWeather(city);
      final weather = WeatherModel.fromJson(json);

      await cacheService.saveLastWeather(weather.cityName, json);

      emit(WeatherLoadSuccess(weather: weather, unit: _unit));
    } on WeatherException catch (e) {
      await _emitFailureWithCacheFallback(e.message, emit);
    } catch (_) {
      await _emitFailureWithCacheFallback(
        'An unexpected error occurred, please try again.',
        emit,
      );
    }
  }

  Future<void> _emitFailureWithCacheFallback(
    String message,
    Emitter<WeatherState> emit,
  ) async {
    final cached = await cacheService.loadLastWeather();
    if (cached != null) {
      final weather = WeatherModel.fromJson(cached.json);
      emit(WeatherLoadFailure(message, cachedWeather: weather, unit: _unit));
    } else {
      emit(WeatherLoadFailure(message, unit: _unit));
    }
  }

  void _onUnitToggled(
    WeatherUnitToggled event,
    Emitter<WeatherState> emit,
  ) {
    _unit = _unit == TemperatureUnit.celsius
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;

    final current = state;
    if (current is WeatherLoadSuccess) {
      emit(current.copyWith(unit: _unit));
    } else if (current is WeatherLoadFailure) {
      emit(WeatherLoadFailure(
        current.message,
        cachedWeather: current.cachedWeather,
        unit: _unit,
      ));
    }
  }

  Future<void> _onCacheLoadRequested(
    WeatherCacheLoadRequested event,
    Emitter<WeatherState> emit,
  ) async {
    final cached = await cacheService.loadLastWeather();
    if (cached != null) {
      final weather = WeatherModel.fromJson(cached.json);
      emit(WeatherLoadSuccess(
        weather: weather,
        unit: _unit,
        isFromCache: true,
      ));
    }
  }
}
