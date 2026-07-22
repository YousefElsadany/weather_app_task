import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class CachedWeatherResult {
  final String city;
  final Map<String, dynamic> json;
  final DateTime? cachedAt;

  const CachedWeatherResult({
    required this.city,
    required this.json,
    this.cachedAt,
  });
}

class WeatherCacheService {
  Future<void> saveLastWeather(String city, Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(CacheKeys.weatherJson, jsonEncode(json));
    await prefs.setString(CacheKeys.cityQuery, city);
    await prefs.setString(CacheKeys.cachedAt, DateTime.now().toIso8601String());
  }

  Future<CachedWeatherResult?> loadLastWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(CacheKeys.weatherJson);
    if (raw == null) return null;

    final city = prefs.getString(CacheKeys.cityQuery) ?? '';
    final cachedAtStr = prefs.getString(CacheKeys.cachedAt);

    return CachedWeatherResult(
      city: city,
      json: jsonDecode(raw) as Map<String, dynamic>,
      cachedAt: cachedAtStr != null ? DateTime.tryParse(cachedAtStr) : null,
    );
  }
}
