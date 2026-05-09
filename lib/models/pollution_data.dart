class PollutionData {
  final String cityName;
  final double aqiValue;
  final String pollutionStatus;
  final double temperature;
  final double humidity;
  final String lastUpdated;
  final String country;
  final double latitude;
  final double longitude;
  final double pm25;
  final double pm10;

  PollutionData({
    required this.cityName,
    required this.aqiValue,
    required this.pollutionStatus,
    required this.temperature,
    required this.humidity,
    required this.lastUpdated,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.pm25 = 0.0,
    this.pm10 = 0.0,
  });

  // Factory constructor for sample data
  factory PollutionData.sample() {
    return PollutionData(
      cityName: 'Lahore',
      aqiValue: 156.0,
      pollutionStatus: 'Unhealthy',
      temperature: 28.5,
      humidity: 65.0,
      lastUpdated: 'Now',
      country: 'Pakistan',
      latitude: 31.5204,
      longitude: 74.3587,
    );
  }

  // Sample data for multiple cities
  static List<PollutionData> sampleCities = [
    PollutionData(
      cityName: 'Lahore',
      aqiValue: 156,
      pollutionStatus: 'Unhealthy',
      temperature: 28.5,
      humidity: 65,
      lastUpdated: 'Now',
      country: 'Pakistan',
      latitude: 31.5204,
      longitude: 74.3587,
    ),
    PollutionData(
      cityName: 'Karachi',
      aqiValue: 142,
      pollutionStatus: 'Unhealthy',
      temperature: 32.1,
      humidity: 72,
      lastUpdated: '5 min ago',
      country: 'Pakistan',
      latitude: 24.8607,
      longitude: 67.0011,
    ),
    PollutionData(
      cityName: 'Islamabad',
      aqiValue: 98,
      pollutionStatus: 'Moderate',
      temperature: 22.3,
      humidity: 55,
      lastUpdated: '10 min ago',
      country: 'Pakistan',
      latitude: 33.6844,
      longitude: 73.0479,
    ),
    PollutionData(
      cityName: 'Rawalpindi',
      aqiValue: 112,
      pollutionStatus: 'Unhealthy for Sensitive Groups',
      temperature: 24.2,
      humidity: 58,
      lastUpdated: '2 min ago',
      country: 'Pakistan',
      latitude: 33.5731,
      longitude: 73.1898,
    ),
    PollutionData(
      cityName: 'Peshawar',
      aqiValue: 168,
      pollutionStatus: 'Unhealthy',
      temperature: 26.8,
      humidity: 68,
      lastUpdated: '8 min ago',
      country: 'Pakistan',
      latitude: 34.0151,
      longitude: 71.5788,
    ),
  ];
}
