import 'package:flutter/material.dart';
import '../models/pollution_data.dart';
import '../widgets/aqi_card.dart';
import '../widgets/loading_animation.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../services/air_quality_service.dart';
import 'prediction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<PollutionData>> _pollutionDataFuture;
  int _selectedBottomIndex = 0;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _pollutionDataFuture = AirQualityService.fetchAllCitiesAirQuality();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Air Quality'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: FutureBuilder<List<PollutionData>>(
        future: _pollutionDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingAnimation(
              message: 'Fetching air quality data...',
            );
          }

          if (snapshot.hasError) {
            return _buildErrorState(context, snapshot.error.toString());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(context);
          }

          final citiesData = snapshot.data!;
          final currentLocation = citiesData.isNotEmpty ? citiesData[0] : PollutionData.sample();

          return RefreshIndicator(
            onRefresh: () async {
              _refreshData();
              await _pollutionDataFuture;
            },
            color: AppTheme.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Location Section
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Location',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        AQICard(
                          data: currentLocation,
                          onTap: () {
                            _showCityDetails(context, currentLocation);
                          },
                        ),
                      ],
                    ),
                  ),

                  // All Cities Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                      vertical: 8,
                    ),
                    child: Text(
                      'All Cities',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),

                  // Cities List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: citiesData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppConstants.defaultPadding,
                        ),
                        child: AQICard(
                          data: citiesData[index],
                          onTap: () {
                            _showCityDetails(
                              context,
                              citiesData[index],
                            );
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomIndex = index;
          });
          _handleBottomNavigation(index);
        },
        backgroundColor: AppTheme.cardBg,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: 'Predictions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppTheme.unhealthyAqi,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Failed to fetch air quality data. Please try again.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Using cached data if available',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox_outlined,
            color: AppTheme.textSecondary,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No Data Available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        // Home - already here
        break;
      case 1:
        // Search
        _showSearchScreen(context);
        break;
      case 2:
        // Predictions
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PredictionScreen(),
          ),
        ).then((_) {
          // Reset to Home when returning
          setState(() {
            _selectedBottomIndex = 0;
          });
        });
        break;
      case 3:
        // Alerts
        _showAlertsScreen(context);
        break;
      case 4:
        // Settings
        _showSettingsScreen(context);
        break;
    }
  }

  void _showCityDetails(BuildContext context, PollutionData data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // City details
              Text(
                data.cityName,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                data.country,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                data.lastUpdated,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              // Details grid
              _buildDetailGrid(context, data),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailGrid(BuildContext context, PollutionData data) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildDetailCard(
          context,
          'AQI Value',
          data.aqiValue.toStringAsFixed(0),
          '🔢',
        ),
        _buildDetailCard(
          context,
          'Status',
          data.pollutionStatus,
          '⚠️',
        ),
        _buildDetailCard(
          context,
          'Temperature',
          '${data.temperature.toStringAsFixed(1)}°C',
          '🌡️',
        ),
        _buildDetailCard(
          context,
          'Humidity',
          '${data.humidity.toStringAsFixed(0)}%',
          '💧',
        ),
        _buildDetailCard(
          context,
          'PM2.5',
          '${data.pm25.toStringAsFixed(1)} µg/m³',
          '💨',
        ),
        _buildDetailCard(
          context,
          'PM10',
          '${data.pm10.toStringAsFixed(1)} µg/m³',
          '💨',
        ),
        _buildDetailCard(
          context,
          'Latitude',
          data.latitude.toStringAsFixed(4),
          '📍',
        ),
        _buildDetailCard(
          context,
          'Longitude',
          data.longitude.toStringAsFixed(4),
          '📍',
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    String label,
    String value,
    String icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceBg,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showSearchScreen(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Search feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAlertsScreen(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alerts feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSettingsScreen(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

