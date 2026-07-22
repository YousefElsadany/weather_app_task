class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.weatherapi.com/v1';
  static const String apiKey = '6f27a7b9512c4882a45162444252101';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}

class CacheKeys {
  CacheKeys._();

  static const String weatherJson = 'cached_weather_json';
  static const String cityQuery = 'cached_weather_city';
  static const String cachedAt = 'cached_weather_time';
}
