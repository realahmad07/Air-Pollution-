import 'package:flutter/material.dart';
import '../models/pollution_data.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class AQICard extends StatelessWidget {
  const AQICard({
    Key? key,
    required this.data,
    this.onTap,
  }) : super(key: key);
  final PollutionData data;
  final VoidCallback? onTap;

  Color _getAQIColor() {
    if (data.aqiValue <= 50) return AppTheme.goodAqi;
    if (data.aqiValue <= 100) return AppTheme.moderateAqi;
    if (data.aqiValue <= 150) return const Color(0xFFFFA500); // Orange
    if (data.aqiValue <= 200) return AppTheme.unhealthyAqi;
    return AppTheme.hazardousAqi;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding),
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.cardBg,
                AppTheme.surfaceBg,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
                BorderRadius.circular(AppConstants.defaultBorderRadius),
            border: Border.all(
              color: _getAQIColor().withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.cityName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.country,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getAQIColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getAQIColor(),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      data.pollutionStatus,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getAQIColor(),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // AQI Value
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AQI',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.aqiValue.toStringAsFixed(0),
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: _getAQIColor(),
                                ),
                      ),
                    ],
                  ),
                  _buildWeatherInfo(context),
                ],
              ),
              const SizedBox(height: 12),
              // Last Updated
              Text(
                'Updated: ${data.lastUpdated}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );

  Widget _buildWeatherInfo(BuildContext context) => Row(
        children: [
          _buildWeatherItem(
            context,
            '🌡️',
            '${data.temperature.toStringAsFixed(1)}°C',
            'Temp',
          ),
          const SizedBox(width: 20),
          _buildWeatherItem(
            context,
            '💧',
            '${data.humidity.toStringAsFixed(0)}%',
            'Humidity',
          ),
        ],
      );

  Widget _buildWeatherItem(
    BuildContext context,
    String icon,
    String value,
    String label,
  ) =>
      Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
}
