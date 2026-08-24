class AppConfig {
  /// Set at build time, for example:
  /// flutter run --dart-define=RAILPULSE_API_URL=https://api.example.in
  static const String gatewayBaseUrl = String.fromEnvironment(
    'RAILPULSE_API_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  /// Demo mode keeps the app fully usable when the gateway is not deployed.
  /// Production builds should pass --dart-define=RAILPULSE_DEMO_MODE=false.
  static const bool demoMode = bool.fromEnvironment(
    'RAILPULSE_DEMO_MODE',
    defaultValue: true,
  );
}
