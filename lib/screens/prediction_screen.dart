import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/pollution_data.dart';
import '../services/air_quality_service.dart';
import '../services/prediction_service.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/loading_animation.dart';
import '../utils/theme.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({Key? key}) : super(key: key);

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  late Future<List<PollutionData>> _pollutionDataFuture;
  String _selectedCity = 'Lahore';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _pollutionDataFuture = AirQualityService.fetchAllCitiesAirQuality();
  }

  void _refreshData() {
    setState(() {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '🤖 AI Predictions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<PollutionData>>(
        future: _pollutionDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimation(message: 'Analyzing pollution data...'),
                  const SizedBox(height: 20),
                  const Text(
                    'AI is generating predictions',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final allCitiesData = snapshot.data!;
          final selectedCityData =
              allCitiesData.firstWhere((city) => city.cityName == _selectedCity);
          final prediction = PredictionService.generatePrediction(selectedCityData);

          return RefreshIndicator(
            onRefresh: () async {
              _refreshData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // City selector
                  _buildCitySelector(allCitiesData),

                  // Main prediction card
                  AIInsightCard(
                    title: '${PredictionService.getAQIEmoji(prediction.predictedAQI)} AI Prediction',
                    subtitle: _getPredictionSubtitle(prediction),
                    riskLevel: prediction.riskLevel,
                    insights: prediction.healthRecommendations,
                    confidenceScore: prediction.confidenceScore,
                    icon: Icons.auto_awesome,
                    emoji: '🤖',
                  ),

                  // Prediction text
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      prediction.prediction,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),

                  // Activity warning
                  _buildActivityWarning(prediction),

                  // Quick metrics
                  _buildQuickMetrics(selectedCityData, prediction),

                  // AQI Trend Chart
                  _buildAQITrendChart(selectedCityData, prediction),

                  // Forecast Chart
                  _buildForecastChart(prediction),

                  // Health recommendations section
                  _buildHealthRecommendations(prediction),

                  // Risk assessment details
                  _buildRiskAssessment(prediction, selectedCityData),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCitySelector(List<PollutionData> cities) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select City',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: cities.map((city) {
                final isSelected = city.cityName == _selectedCity;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCity = city.cityName;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.white.withValues(alpha: 0.05),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.white.withValues(alpha: 0.1),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      city.cityName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityWarning(PollutionPrediction prediction) {
    final riskColor = _getRiskColor(prediction.riskLevel);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: riskColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: riskColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning, color: riskColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              prediction.activityWarning,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMetrics(
    PollutionData cityData,
    PollutionPrediction prediction,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Metrics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              QuickInsightCard(
                title: 'Current AQI',
                value: cityData.aqiValue.toStringAsFixed(0),
                subtitle: cityData.pollutionStatus,
                backgroundColor: AppTheme.primaryColor,
                icon: Icons.air,
              ),
              QuickInsightCard(
                title: 'Predicted AQI',
                value: prediction.predictedAQI.toStringAsFixed(0),
                subtitle: PredictionService.getTrendAnalysis(
                  cityData.aqiValue,
                  prediction.predictedAQI,
                ),
                backgroundColor: AppTheme.primaryColor,
                icon: Icons.trending_up,
              ),
              QuickInsightCard(
                title: 'Confidence',
                value: '${prediction.confidenceScore.toStringAsFixed(0)}%',
                subtitle: 'Prediction accuracy',
                backgroundColor: AppTheme.secondaryColor,
                icon: Icons.thumb_up,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAQITrendChart(
    PollutionData cityData,
    PollutionPrediction prediction,
  ) {
    // Simulate hourly data for the last 24 hours
    final List<FlSpot> dataPoints = [];
    for (int i = 0; i < 24; i++) {
      // Create realistic trend with current and predicted values
      final value = cityData.aqiValue +
          (prediction.predictedAQI - cityData.aqiValue) * (i / 24);
      dataPoints.add(FlSpot(i.toDouble(), value.clamp(0, 500)));
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 AQI Trend (24 Hours)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 3,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}h',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: dataPoints,
                    isCurved: true,
                    color: AppTheme.primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                ],
                minX: 0,
                maxX: 23,
                minY: 0,
                maxY: 300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastChart(PollutionPrediction prediction) {
    // Simulate 7-day forecast
    final List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < 7; i++) {
      final variance = (i - 3).abs() * 5.0;
      final value = prediction.predictedAQI + variance;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: value.clamp(0, 400),
              color: _getForecastColor(value),
              width: 16,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📈 7-Day Forecast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Text(
                          days[value.toInt()],
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: 400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthRecommendations(PollutionPrediction prediction) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💊 Health Recommendations',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: List.generate(
                prediction.healthRecommendations.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index < prediction.healthRecommendations.length - 1
                        ? 12
                        : 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}.',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          prediction.healthRecommendations[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskAssessment(
    PollutionPrediction prediction,
    PollutionData cityData,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚠️ Risk Assessment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildRiskRow(
                  'Risk Level',
                  prediction.riskLevel,
                  _getRiskColor(prediction.riskLevel),
                ),
                const SizedBox(height: 12),
                _buildRiskRow(
                  'PM2.5 Level',
                  '${cityData.pm25.toStringAsFixed(1)} µg/m³',
                  cityData.pm25 > 75 ? Colors.red : AppTheme.primaryColor,
                ),
                const SizedBox(height: 12),
                _buildRiskRow(
                  'PM10 Level',
                  '${cityData.pm10.toStringAsFixed(1)} µg/m³',
                  cityData.pm10 > 150 ? Colors.red : AppTheme.primaryColor,
                ),
                const SizedBox(height: 12),
                _buildRiskRow(
                  'Temperature',
                  '${cityData.temperature.toStringAsFixed(1)}°C',
                  AppTheme.primaryColor,
                ),
                const SizedBox(height: 12),
                _buildRiskRow(
                  'Humidity',
                  '${cityData.humidity.toStringAsFixed(0)}%',
                  cityData.humidity > 70
                      ? AppTheme.secondaryColor
                      : Colors.white70,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Failed to load predictions',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _refreshData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, color: Colors.white54, size: 48),
          const SizedBox(height: 16),
          const Text(
            'No data available',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _refreshData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  String _getPredictionSubtitle(PollutionPrediction prediction) {
    final trend = PredictionService.getTrendAnalysis(
      AirQualityService.cityCoordinates['Lahore']?['lat'] ?? 31.5204,
      prediction.predictedAQI,
    );
    return trend;
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'CRITICAL':
        return const Color(0xFF8B00FF);
      case 'HIGH':
        return const Color(0xFFF44336);
      case 'MODERATE':
        return const Color(0xFFFF9800);
      case 'LOW':
        return const Color(0xFFFFC107);
      case 'MINIMAL':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF1B5E20);
    }
  }

  Color _getForecastColor(double aqiValue) {
    if (aqiValue <= 50) {
      return const Color(0xFF4CAF50);
    } else if (aqiValue <= 100) {
      return const Color(0xFFFFC107);
    } else if (aqiValue <= 150) {
      return const Color(0xFFFF9800);
    } else if (aqiValue <= 200) {
      return const Color(0xFFF44336);
    } else {
      return const Color(0xFF8B00FF);
    }
  }
}
