class ApiConfig {
  // Base URL (Easily switchable between Dev and Prod)
  static const String baseUrlDev = 'https://api-dev.inframind-egypt.gov.eg/v1';
  static const String baseUrlProd = 'https://api.inframind-egypt.gov.eg/v1';
  
  static const bool useProduction = false;

  static String get baseUrl => useProduction ? baseUrlProd : baseUrlDev;

  static const Duration timeout = Duration(seconds: 30);

  // Authentication Token (Bearer Token placeholder ready)
  static String? authToken = 'inframind_egypt_secure_token_2026';

  // Endpoints
  static const String roadIssues = '/roads/issues';
  static const String roadStats = '/roads/stats';
  static const String liveDetectionStream = '/ai/live-stream';
  static const String reportSubmit = '/reports/submit';
}
