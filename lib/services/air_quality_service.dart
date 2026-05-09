import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/pollution_data.dart';

class AirQualityService {
  static const String _cacheKeyPrefix = 'aqi_cache_';
  static const Duration _cacheDuration = Duration(hours: 1);

  // City coordinates for fetching data
  static const Map<String, Map<String, double>> cityCoordinates = {
    'Lahore': {'lat': 31.5204, 'lon': 74.3587},
    'Karachi': {'lat': 24.8607, 'lon': 67.0011},
    'Islamabad': {'lat': 33.6844, 'lon': 73.0479},
    'Rawalpindi': {'lat': 33.5731, 'lon': 73.1898},
    'Peshawar': {'lat': 34.0151, 'lon': 71.5788},
  };

  // Fetch single city's air quality data
  static Future<PollutionData> fetchCityAirQuality(String cityName) async {
    try {
      final coords = cityCoordinates[cityName];
      if (coords == null) {
        throw Exception('City not found');
      }

      // Try to get cached data first
      final cached = await _getCachedData(cityName);
      if (cached != null) {
        return cached;
      }

      // Fetch from API
      final data =
          await _fetchFromAPI(cityName, coords['lat']!, coords['lon']!);

      // Cache the data
      await _cacheData(cityName, data);

      return data;
    } catch (e) {
      // Return cached data if API fails
      final cached = await _getCachedData(cityName);
      if (cached != null) {
        return cached;
      }

      // Return sample data as last resort
      return _getSampleData(cityName);
    }
  }

  // Fetch air quality data from API
  static Future<PollutionData> _fetchFromAPI(
    String cityName,
    double latitude,
    double longitude,
  ) async {
    try {
      // Using Open-Meteo API for air quality (completely free, no auth needed)
      final url = Uri.parse(
        'https://air-quality-api.open-meteo.com/v1/air-quality'
        '?latitude=$latitude&longitude=$longitude'
        '&hourly=pm2_5,pm10,nitrogen_dioxide'
        '&current=pm2_5,pm10,nitrogen_dioxide,temperature'
        '&timezone=auto',
      );

      final response = await http.get(url).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('API request timeout'),
          );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return _parseAirQualityResponse(json, cityName);
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  // Parse API response and create PollutionData object
  static PollutionData _parseAirQualityResponse(
    Map<String, dynamic> json,
    String cityName,
  ) {
    try {
      final current = json['current'] ?? {};
      final pm25 = (current['pm2_5'] as num?)?.toDouble() ?? 50.0;
      final pm10 = (current['pm10'] as num?)?.toDouble() ?? 60.0;
      final temperature = (current['temperature'] as num?)?.toDouble() ?? 25.0;
      final country = _getCountryForCity(cityName);

      // Calculate AQI from PM2.5 using EPA formula
      final aqiValue = _calculateAQI(pm25);

      // Determine pollution status based on AQI
      final status = _getStatusFromAQI(aqiValue);

      // Mock humidity (in real scenario, use weather API)
      final humidity = _getEstimatedHumidity(cityName);

      // Get coordinates
      final coords = cityCoordinates[cityName]!;

      return PollutionData(
        cityName: cityName,
        aqiValue: aqiValue,
        pollutionStatus: status,
        temperature: temperature,
        humidity: humidity,
        lastUpdated: 'Now',
        country: country,
        latitude: coords['lat']!,
        longitude: coords['lon']!,
        pm25: pm25,
        pm10: pm10,
      );
    } catch (e) {
      throw Exception('Failed to parse response: $e');
    }
  }

  // Calculate AQI from PM2.5 using EPA AQI formula
  static double _calculateAQI(double pm25) {
    if (pm25 <= 12) {
      return (pm25 / 12) * 50;
    } else if (pm25 <= 35.4) {
      return ((pm25 - 12) / 23.4) * 50 + 50;
    } else if (pm25 <= 55.4) {
      return ((pm25 - 35.4) / 20) * 50 + 100;
    } else if (pm25 <= 150.4) {
      return ((pm25 - 55.4) / 95) * 50 + 150;
    } else if (pm25 <= 250.4) {
      return ((pm25 - 150.4) / 100) * 50 + 200;
    } else {
      return ((pm25 - 250.4) / 500) * 50 + 300;
    }
  }

  // Get pollution status from AQI value
  static String _getStatusFromAQI(double aqiValue) {
    if (aqiValue <= 50) {
      return 'Good';
    } else if (aqiValue <= 100) {
      return 'Moderate';
    } else if (aqiValue <= 150) {
      return 'Unhealthy for Sensitive Groups';
    } else if (aqiValue <= 200) {
      return 'Unhealthy';
    } else if (aqiValue <= 300) {
      return 'Very Unhealthy';
    } else {
      return 'Hazardous';
    }
  }

  // Get estimated humidity based on city (mock data)
  static double _getEstimatedHumidity(String cityName) {
    final humidityMap = {
      'Lahore': 65.0,
      'Karachi': 72.0,
      'Islamabad': 55.0,
      'Rawalpindi': 58.0,
      'Peshawar': 68.0,
    };
    return humidityMap[cityName] ?? 60.0;
  }

  // Get country for city
  static String _getCountryForCity(String cityName) {
    return 'Pakistan';
  }

  // Cache data using shared_preferences
  static Future<void> _cacheData(String cityName, PollutionData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_cacheKeyPrefix$cityName';
      final json = {
        'cityName': data.cityName,
        'aqiValue': data.aqiValue,
        'pollutionStatus': data.pollutionStatus,
        'temperature': data.temperature,
        'humidity': data.humidity,
        'country': data.country,
        'latitude': data.latitude,
        'longitude': data.longitude,
        'pm25': data.pm25,
        'pm10': data.pm10,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await prefs.setString(key, jsonEncode(json));
    } catch (e) {
      // Silently fail caching
      debugPrint('Cache error: $e');
    }
  }

  // Get cached data if not expired
  static Future<PollutionData?> _getCachedData(String cityName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_cacheKeyPrefix$cityName';
      final cached = prefs.getString(key);

      if (cached == null) return null;

      final json = jsonDecode(cached) as Map<String, dynamic>;
      final timestamp = DateTime.parse(json['timestamp'] as String);

      // Check if cache is still valid
      if (DateTime.now().difference(timestamp) > _cacheDuration) {
        return null;
      }

      return PollutionData(
        cityName: json['cityName'] as String,
        aqiValue: (json['aqiValue'] as num).toDouble(),
        pollutionStatus: json['pollutionStatus'] as String,
        temperature: (json['temperature'] as num).toDouble(),
        humidity: (json['humidity'] as num).toDouble(),
        lastUpdated: 'Cached',
        country: json['country'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        pm25: (json['pm25'] as num?)?.toDouble() ?? 0.0,
        pm10: (json['pm10'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      debugPrint('Cached data error: $e');
      return null;
    }
  }

  // Get sample data as fallback
  static PollutionData _getSampleData(String cityName) {
    final samples = {
      'Lahore': PollutionData(
        cityName: 'Lahore',
        aqiValue: 156.0,
        pollutionStatus: 'Unhealthy',
        temperature: 28.5,
        humidity: 65.0,
        lastUpdated: 'Sample',
        country: 'Pakistan',
        latitude: 31.5204,
        longitude: 74.3587,
      ),
      'Karachi': PollutionData(
        cityName: 'Karachi',
        aqiValue: 142.0,
        pollutionStatus: 'Unhealthy',
        temperature: 32.1,
        humidity: 72.0,
        lastUpdated: 'Sample',
        country: 'Pakistan',
        latitude: 24.8607,
        longitude: 67.0011,
      ),
      'Islamabad': PollutionData(
        cityName: 'Islamabad',
        aqiValue: 98.0,
        pollutionStatus: 'Moderate',
        temperature: 22.3,
        humidity: 55.0,
        lastUpdated: 'Sample',
        country: 'Pakistan',
        latitude: 33.6844,
        longitude: 73.0479,
      ),
      'Rawalpindi': PollutionData(
        cityName: 'Rawalpindi',
        aqiValue: 112.0,
        pollutionStatus: 'Unhealthy for Sensitive Groups',
        temperature: 24.2,
        humidity: 58.0,
        lastUpdated: 'Sample',
        country: 'Pakistan',
        latitude: 33.5731,
        longitude: 73.1898,
      ),
      'Peshawar': PollutionData(
        cityName: 'Peshawar',
        aqiValue: 168.0,
        pollutionStatus: 'Unhealthy',
        temperature: 26.8,
        humidity: 68.0,
        lastUpdated: 'Sample',
        country: 'Pakistan',
        latitude: 34.0151,
        longitude: 71.5788,
      ),
    };

    return samples[cityName] ?? PollutionData.sample();
  }

  // Fetch data for all cities
  static Future<List<PollutionData>> fetchAllCitiesAirQuality() async {
    final cities = cityCoordinates.keys.toList();
    final results = <PollutionData>[];

    for (final city in cities) {
      try {
        final data = await fetchCityAirQuality(city);
        results.add(data);
      } catch (e) {
        debugPrint('Error fetching $city: $e');
        results.add(_getSampleData(city));
      }
    }

    return results;
  }

  // Clear all cached data
  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_cacheKeyPrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      debugPrint('Clear cache error: $e');
    }
  }
}
