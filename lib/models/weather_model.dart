import 'package:equatable/equatable.dart';

class WeatherModel extends Equatable {
  final String cityName;
  final String region;
  final String country;
  final String localTime;

  final double tempC;
  final double tempF;
  final double feelsLikeC;
  final double feelsLikeF;

  final String conditionText;
  final String conditionIconUrl;
  final int conditionCode;
  final bool isDay;

  final int humidity;
  final double windKph;
  final double windMph;
  final String lastUpdated;

  const WeatherModel({
    required this.cityName,
    required this.region,
    required this.country,
    required this.localTime,
    required this.tempC,
    required this.tempF,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.conditionText,
    required this.conditionIconUrl,
    required this.conditionCode,
    required this.isDay,
    required this.humidity,
    required this.windKph,
    required this.windMph,
    required this.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>? ?? {};
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final condition = current['condition'] as Map<String, dynamic>? ?? {};

    String iconUrl = (condition['icon'] as String? ?? '').trim();
    if (iconUrl.startsWith('//')) {
      iconUrl = 'https:$iconUrl';
    }

    return WeatherModel(
      cityName: location['name'] as String? ?? 'Unknown',
      region: location['region'] as String? ?? '',
      country: location['country'] as String? ?? '',
      localTime: location['localtime'] as String? ?? '',
      tempC: (current['temp_c'] as num?)?.toDouble() ?? 0,
      tempF: (current['temp_f'] as num?)?.toDouble() ?? 0,
      feelsLikeC: (current['feelslike_c'] as num?)?.toDouble() ?? 0,
      feelsLikeF: (current['feelslike_f'] as num?)?.toDouble() ?? 0,
      conditionText: condition['text'] as String? ?? '',
      conditionIconUrl: iconUrl,
      conditionCode: (condition['code'] as num?)?.toInt() ?? 0,
      isDay: (current['is_day'] as num?) == 1,
      humidity: (current['humidity'] as num?)?.toInt() ?? 0,
      windKph: (current['wind_kph'] as num?)?.toDouble() ?? 0,
      windMph: (current['wind_mph'] as num?)?.toDouble() ?? 0,
      lastUpdated: current['last_updated'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
        cityName,
        region,
        country,
        localTime,
        tempC,
        tempF,
        feelsLikeC,
        feelsLikeF,
        conditionText,
        conditionIconUrl,
        conditionCode,
        isDay,
        humidity,
        windKph,
        windMph,
        lastUpdated,
      ];
}
