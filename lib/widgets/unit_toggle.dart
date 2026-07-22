import 'package:flutter/material.dart';
import '../bloc/weather_state.dart';
import '../core/theme/app_theme.dart';

/// Small °C / °F segmented switch. Purely presentational - the parent
/// decides what happens when it's tapped.
class UnitToggle extends StatelessWidget {
  final TemperatureUnit unit;
  final VoidCallback onToggle;

  const UnitToggle({
    super.key,
    required this.unit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isCelsius = unit == TemperatureUnit.celsius;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSegment('°C', isCelsius),
            _buildSegment('°F', !isCelsius),
          ],
        ),
      ),
    );
  }

  Widget _buildSegment(String label, bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : AppColors.textMuted,
        ),
      ),
    );
  }
}
