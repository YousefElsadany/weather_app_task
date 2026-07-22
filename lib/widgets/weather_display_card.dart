import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/weather_state.dart';
import '../core/theme/app_theme.dart';
import '../models/weather_model.dart';
import 'unit_toggle.dart';

/// The main card shown once weather data is available: city, large temperature
/// reading, condition icon/text, and a few secondary stats.
class WeatherDisplayCard extends StatelessWidget {
  final WeatherModel weather;
  final TemperatureUnit unit;
  final VoidCallback onToggleUnit;
  final bool isFromCache;

  const WeatherDisplayCard({
    super.key,
    required this.weather,
    required this.unit,
    required this.onToggleUnit,
    this.isFromCache = false,
  });

  double get _temp =>
      unit == TemperatureUnit.celsius ? weather.tempC : weather.tempF;

  double get _feelsLike =>
      unit == TemperatureUnit.celsius ? weather.feelsLikeC : weather.feelsLikeF;

  String get _unitSymbol => unit == TemperatureUnit.celsius ? '°C' : '°F';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isFromCache) _buildCacheBanner(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${weather.cityName}, ${weather.country}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                UnitToggle(unit: unit, onToggle: onToggleUnit),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              weather.localTime,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: weather.conditionIconUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(
                    width: 72,
                    height: 72,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.cloud_off,
                    size: 56,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${_temp.round()} $_unitSymbol',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              weather.conditionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.blueGrey.withValues(alpha: 0.15)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(
                  icon: Icons.thermostat,
                  label: 'Feels Like',
                  value: '${_feelsLike.round()}$_unitSymbol',
                ),
                _StatItem(
                  icon: Icons.water_drop_outlined,
                  label: 'Humidity',
                  value: '${weather.humidity}%',
                ),
                _StatItem(
                  icon: Icons.air,
                  label: 'Wind',
                  value: '${weather.windKph.round()} km/h',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, size: 22, color: Colors.orange),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Saved data from the last successful connection (offline mode)',
              style: TextStyle(fontSize: 12.5, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accentBlue),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
