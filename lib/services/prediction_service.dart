import 'package:flutter/foundation.dart';
import '../models/pollution_data.dart';

class PollutionPrediction {
  final String cityName;
  final double predictedAQI;
  final String prediction;
  final String riskLevel;
  final List<String> healthRecommendations;
  final String activityWarning;
  final DateTime predictionTime;
  final double confidenceScore;

  PollutionPrediction({
    required this.cityName,
    required this.predictedAQI,
    required this.prediction,
    required this.riskLevel,
    required this.healthRecommendations,
    required this.activityWarning,
    required this.predictionTime,
    required this.confidenceScore,
  });
}

class PredictionService {
  // Generate AI prediction based on current pollution data and simple algorithms
  static PollutionPrediction generatePrediction(PollutionData currentData) {
    try {
      final aqiValue = currentData.aqiValue;
      final pm25 = currentData.pm25;
      final pm10 = currentData.pm10;
      final temperature = currentData.temperature;
      final humidity = currentData.humidity;

      // Calculate trend-based prediction
      final predictedAQI = _predictAQI(aqiValue, temperature, humidity);
      final prediction = _generatePredictionText(aqiValue, predictedAQI);
      final riskLevel = _calculateRiskLevel(predictedAQI, pm25, pm10);
      final recommendations = _generateHealthRecommendations(
        predictedAQI,
        pm25,
        currentData.pollutionStatus,
      );
      final warning = _generateActivityWarning(predictedAQI, pm25);
      final confidence = _calculateConfidence(aqiValue, temperature, humidity);

      return PollutionPrediction(
        cityName: currentData.cityName,
        predictedAQI: predictedAQI,
        prediction: prediction,
        riskLevel: riskLevel,
        healthRecommendations: recommendations,
        activityWarning: warning,
        predictionTime: DateTime.now(),
        confidenceScore: confidence,
      );
    } catch (e) {
      debugPrint('Prediction error: $e');
      return _getDefaultPrediction(currentData);
    }
  }

  // Predict future AQI based on current conditions
  static double _predictAQI(double currentAQI, double temp, double humidity) {
    // Simple prediction algorithm
    var predictedAQI = currentAQI;

    // Temperature effect: Higher temp increases pollution slightly
    if (temp > 30) {
      predictedAQI += (temp - 30) * 0.5;
    } else if (temp < 15) {
      predictedAQI -= (15 - temp) * 0.3;
    }

    // Humidity effect: High humidity disperses pollution
    if (humidity > 70) {
      predictedAQI -= humidity * 0.2;
    } else if (humidity < 40) {
      predictedAQI += (40 - humidity) * 0.3;
    }

    // Add small random variation to simulate real-world changes
    predictedAQI += (currentAQI * 0.05); // +5% variance

    // Ensure AQI stays within valid range
    return predictedAQI.clamp(0, 500);
  }

  // Generate prediction text based on AQI values
  static String _generatePredictionText(double currentAQI, double predictedAQI) {
    final change = predictedAQI - currentAQI;

    if (predictedAQI >= 300) {
      return '🔴 HAZARDOUS CONDITIONS PREDICTED\nExtreme pollution levels expected. Stay indoors.';
    } else if (predictedAQI >= 200) {
      if (change > 20) {
        return '⚠️ Air quality will WORSEN significantly tomorrow.\nVery unhealthy conditions expected.';
      } else if (change < -20) {
        return '✅ Air quality will IMPROVE significantly.\nExpect better conditions soon.';
      }
      return '⚠️ Very unhealthy conditions predicted.\nLimit outdoor activities.';
    } else if (predictedAQI >= 150) {
      if (change > 30) {
        return '⚠️ Air quality may worsen tomorrow.\nUnhealthy conditions possible.';
      } else if (change < -20) {
        return '✅ Air quality expected to improve.\nConditions becoming healthier.';
      }
      return '⚠️ Unhealthy for sensitive groups predicted.\nVulnerable populations at risk.';
    } else if (predictedAQI >= 100) {
      if (change > 25) {
        return '⚠️ Moderate pollution expected in next 24 hours.\nConditions may worsen.';
      } else if (change < -15) {
        return '✅ Air quality improving.\nModerate conditions continuing.';
      }
      return '🟡 Moderate air quality predicted.\nSensitive people should limit outdoor time.';
    } else if (predictedAQI >= 50) {
      return '🟢 Good air quality predicted.\nSafe for outdoor activities.';
    } else {
      return '✅ Excellent air quality predicted.\nPerfect conditions for outdoor activities.';
    }
  }

  // Calculate risk level based on multiple factors
  static String _calculateRiskLevel(
    double predictedAQI,
    double pm25,
    double pm10,
  ) {
    // Risk calculation based on AQI and PM levels
    var riskScore = 0.0;

    // AQI component (0-100)
    if (predictedAQI <= 50) {
      riskScore += 0;
    } else if (predictedAQI <= 100) {
      riskScore += 15;
    } else if (predictedAQI <= 150) {
      riskScore += 35;
    } else if (predictedAQI <= 200) {
      riskScore += 60;
    } else if (predictedAQI <= 300) {
      riskScore += 80;
    } else {
      riskScore += 100;
    }

    // PM2.5 component (0-30)
    if (pm25 <= 12) {
      riskScore += 0;
    } else if (pm25 <= 35) {
      riskScore += 10;
    } else if (pm25 <= 75) {
      riskScore += 20;
    } else {
      riskScore += 30;
    }

    // PM10 component (0-20)
    if (pm10 <= 50) {
      riskScore += 0;
    } else if (pm10 <= 100) {
      riskScore += 8;
    } else if (pm10 <= 200) {
      riskScore += 15;
    } else {
      riskScore += 20;
    }

    // Normalize to 0-100
    riskScore = riskScore.clamp(0, 150);
    final normalizedScore = (riskScore / 150) * 100;

    if (normalizedScore >= 80) {
      return 'CRITICAL';
    } else if (normalizedScore >= 60) {
      return 'HIGH';
    } else if (normalizedScore >= 40) {
      return 'MODERATE';
    } else if (normalizedScore >= 20) {
      return 'LOW';
    } else {
      return 'MINIMAL';
    }
  }

  // Generate health recommendations based on pollution level
  static List<String> _generateHealthRecommendations(
    double predictedAQI,
    double pm25,
    String pollutionStatus,
  ) {
    final recommendations = <String>[];

    // AQI-based recommendations
    if (predictedAQI >= 300) {
      recommendations.addAll([
        '🏠 Stay indoors entirely',
        '🚪 Keep windows and doors closed',
        '🌬️ Use air purifier if available',
        '💨 Switch to recirculated air in vehicles',
        '⚕️ Contact doctor if experiencing symptoms',
        '🛏️ Minimize physical exertion',
      ]);
    } else if (predictedAQI >= 200) {
      recommendations.addAll([
        '🏠 Remain indoors - avoid outdoor activities',
        '🚭 Wear N95 mask if must go outside',
        '👨‍👩‍👧‍👦 Keep children and elderly indoors',
        '💊 Take prescribed medications',
        '🌬️ Use air purifier or filter',
        '💧 Stay hydrated',
      ]);
    } else if (predictedAQI >= 150) {
      recommendations.addAll([
        '⚠️ Reduce outdoor activities',
        '🚭 Wear N95 mask for prolonged outdoor time',
        '👶 Sensitive groups should stay indoors',
        '🏃 Avoid strenuous outdoor exercise',
        '💨 Close windows and use AC filter',
        '🚗 Avoid rush hour commuting if possible',
      ]);
    } else if (predictedAQI >= 100) {
      recommendations.addAll([
        '🟡 Limit prolonged outdoor exertion',
        '👥 Sensitive people should limit outdoor time',
        '😷 Consider masks for vulnerable groups',
        '🏃 Moderate activity is acceptable',
        '🌬️ Consider air purification at home',
        '💨 Be aware of symptoms',
      ]);
    } else if (predictedAQI >= 50) {
      recommendations.addAll([
        '✅ Generally safe for outdoor activities',
        '👨‍👩‍👧 Most people can exercise outside',
        '🌤️ Good day for outdoor plans',
        '🚴 Cycling and jogging acceptable',
        '☺️ No special precautions needed',
        '🌞 Enjoy outdoor activities',
      ]);
    } else {
      recommendations.addAll([
        '✅ Excellent air quality',
        '🏃 Perfect conditions for exercise',
        '👨‍👩‍👧 All outdoor activities safe',
        '🌤️ Great for outdoor recreation',
        '☀️ No pollution concerns',
        '🎉 Ideal weather conditions',
      ]);
    }

    // PM2.5-specific warnings
    if (pm25 > 150) {
      if (!recommendations.contains('🚭 Wear N95 mask if must go outside')) {
        recommendations.insert(0, '⚠️ HIGH PM2.5: Very small particles detected');
      }
    } else if (pm25 > 75) {
      if (!recommendations.contains('🚭 Wear N95 mask for prolonged outdoor time')) {
        recommendations.insert(
          0,
          '⚠️ ELEVATED PM2.5: Fine particles at concerning levels',
        );
      }
    }

    return recommendations.take(6).toList(); // Return top 6 recommendations
  }

  // Generate outdoor activity warning
  static String _generateActivityWarning(double predictedAQI, double pm25) {
    if (predictedAQI >= 300) {
      return '🚫 ALL outdoor activities PROHIBITED\nStay indoors for safety';
    } else if (predictedAQI >= 200) {
      if (pm25 > 150) {
        return '⛔ High PM2.5 DETECTED\nDo not exercise outdoors';
      }
      return '⛔ Very unhealthy conditions\nSevere restrictions recommended';
    } else if (predictedAQI >= 150) {
      return '⚠️ Sensitive groups should avoid\nOutdoor sports not recommended';
    } else if (predictedAQI >= 100) {
      if (pm25 > 75) {
        return '🟡 Moderate PM2.5 levels\nLimit strenuous outdoor exercise';
      }
      return '🟡 Moderate pollution\nSensitive people should limit activities';
    } else if (predictedAQI >= 50) {
      return '✅ Outdoor activities acceptable\nNo major restrictions';
    } else {
      return '✅ Excellent conditions\nAll outdoor activities encouraged';
    }
  }

  // Calculate confidence score (0-100) based on input data quality
  static double _calculateConfidence(
    double aqiValue,
    double temperature,
    double humidity,
  ) {
    var confidence = 75.0; // Base confidence

    // Increase confidence if data seems reliable
    if (aqiValue >= 0 && aqiValue <= 500) confidence += 10;
    if (temperature >= 0 && temperature <= 50) confidence += 8;
    if (humidity >= 0 && humidity <= 100) confidence += 7;

    // Decrease confidence for extreme values (might be outliers)
    if (aqiValue > 400) confidence -= 5;
    if (temperature > 45 || temperature < -10) confidence -= 5;

    return confidence.clamp(0, 100);
  }

  // Default prediction for error handling
  static PollutionPrediction _getDefaultPrediction(PollutionData data) {
    return PollutionPrediction(
      cityName: data.cityName,
      predictedAQI: data.aqiValue,
      prediction: 'Unable to generate prediction. Using current data.',
      riskLevel: 'MODERATE',
      healthRecommendations: [
        'Check current air quality conditions',
        'Monitor official sources for updates',
        'Use air quality app regularly',
        'Stay informed about pollution levels',
        'Follow local health guidelines',
        'Use air purifiers if available',
      ],
      activityWarning: 'Check current conditions before outdoor activities',
      predictionTime: DateTime.now(),
      confidenceScore: 50.0,
    );
  }

  // Generate predictions for all cities
  static List<PollutionPrediction> generateAllPredictions(
    List<PollutionData> allCitiesData,
  ) {
    return allCitiesData.map((data) => generatePrediction(data)).toList();
  }

  // Get trend analysis (improving/worsening)
  static String getTrendAnalysis(double currentAQI, double predictedAQI) {
    final change = predictedAQI - currentAQI;
    final percentChange = (change / currentAQI * 100).abs();

    if (change > 20) {
      return '📈 WORSENING TREND (${percentChange.toStringAsFixed(1)}%)';
    } else if (change < -20) {
      return '📉 IMPROVING TREND (${percentChange.toStringAsFixed(1)}%)';
    } else {
      return '➡️ STABLE CONDITIONS (${percentChange.toStringAsFixed(1)}%)';
    }
  }

  // Get emoji based on AQI
  static String getAQIEmoji(double aqiValue) {
    if (aqiValue <= 50) {
      return '✅';
    } else if (aqiValue <= 100) {
      return '🟡';
    } else if (aqiValue <= 150) {
      return '🟠';
    } else if (aqiValue <= 200) {
      return '🔴';
    } else if (aqiValue <= 300) {
      return '🟣';
    } else {
      return '☠️';
    }
  }

  // Get color based on risk level
  static String getRiskColor(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'CRITICAL':
        return '#8B00FF'; // Purple
      case 'HIGH':
        return '#F44336'; // Red
      case 'MODERATE':
        return '#FF9800'; // Orange
      case 'LOW':
        return '#FFC107'; // Yellow
      case 'MINIMAL':
        return '#4CAF50'; // Green
      default:
        return '#1B5E20'; // Default green
    }
  }
}
