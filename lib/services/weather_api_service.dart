import 'package:dio/dio.dart';
import '../core/constants.dart';

class WeatherException implements Exception {
  final String message;
  const WeatherException(this.message);

  @override
  String toString() => message;
}

class WeatherApiService {
  final Dio _dio;

  WeatherApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: ApiConstants.connectTimeout,
                receiveTimeout: ApiConstants.receiveTimeout,
              ),
            );

  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/current.json',
        queryParameters: {
          'key': ApiConstants.apiKey,
          'q': city.trim(),
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  WeatherException _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const WeatherException(
          'Connection timed out. Make sure you are connected to the internet and try again.',
        );
      case DioExceptionType.connectionError:
        return const WeatherException(
          'There is no internet connection. Please check your network and try again.',
        );
      case DioExceptionType.badResponse:
        return _mapBadResponse(e);
      default:
        return const WeatherException('An unexpected error occurred. Please try again.');
    }
  }

  WeatherException _mapBadResponse(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    // WeatherAPI.com error shape: { "error": { "code": 1006, "message": "..." } }
    if (data is Map && data['error'] is Map) {
      final apiMessage = data['error']['message'] as String?;
      if (statusCode == 400) {
        return const WeatherException(
          'The city name is invalid or does not exist. Try another name.',
        );
      }
      if (apiMessage != null && apiMessage.isNotEmpty) {
        return WeatherException(apiMessage);
      }
    }

    if (statusCode == 401 || statusCode == 403) {
      return const WeatherException('There is a problem with the API key.');
    }

    return WeatherException('An error occurred while fetching data (code $statusCode).');
  }
}
