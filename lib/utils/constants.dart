class AppStrings {
  // App Name
  static const String appName = 'Pollution Monitor';

  // Splash Screen
  static const String splashTitle = 'Pollution Monitor';
  static const String splashSubtitle = 'Real-time Air Quality Information';

  // Login Screen
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle = 'Sign in to your account';
  static const String emailLabel = 'Email Address';
  static const String passwordLabel = 'Password';
  static const String loginButton = 'Login';
  static const String noAccount = 'Don\'t have an account? ';
  static const String signupLink = 'Sign up';
  static const String forgotPassword = 'Forgot Password?';

  // Signup Screen
  static const String signupTitle = 'Create Account';
  static const String signupSubtitle = 'Join us to monitor air quality';
  static const String fullNameLabel = 'Full Name';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String signupButton = 'Create Account';
  static const String haveAccount = 'Already have an account? ';
  static const String loginLink = 'Login';
  static const String agreeTerms = 'I agree to Terms & Conditions';

  // Home Screen
  static const String homeTitle = 'Air Quality';
  static const String currentLocation = 'Current Location';
  static const String allCities = 'All Cities';
  static const String aqi = 'AQI';
  static const String status = 'Status';
  static const String temperature = 'Temperature';
  static const String humidity = 'Humidity';
  static const String lastUpdated = 'Last Updated';
  static const String viewDetails = 'View Details';
  static const String refresh = 'Refresh';

  // AQI Status
  static const String good = 'Good';
  static const String moderate = 'Moderate';
  static const String unhealthySensitive = 'Unhealthy for Sensitive Groups';
  static const String unhealthy = 'Unhealthy';
  static const String veryUnhealthy = 'Very Unhealthy';
  static const String hazardous = 'Hazardous';

  // Navigation
  static const String home = 'Home';
  static const String search = 'Search';
  static const String alerts = 'Alerts';
  static const String settings = 'Settings';
}

class AppConstants {
  static const double defaultPadding = 16;
  static const double defaultBorderRadius = 12;
  static const int animationDuration = 500;

  // AQI Ranges
  static const int aqi_Good = 50;
  static const int aqi_Moderate = 100;
  static const int aqi_UnhealthySensitive = 150;
  static const int aqi_Unhealthy = 200;
  static const int aqi_VeryUnhealthy = 300;
}
