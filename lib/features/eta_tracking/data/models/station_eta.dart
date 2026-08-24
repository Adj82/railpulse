class StationEta {
  final String stationCode;
  final String stationName;
  final DateTime scheduledArrival;
  final DateTime p10; // Optimistic (ML)
  final DateTime p50; // Median/Expected (ML)
  final DateTime p90; // Pessimistic/Likely (ML)

  // SIH PS26028 specific factors
  final String? bottleneckReason; // e.g., "Signal Wait", "Platform Maintenance"
  final int congestionIndex; // 0-100%
  final String? weatherImpact; // e.g., "Moderate Fog"
  final double sectionalSpeedLimit;

  StationEta({
    required this.stationCode,
    required this.stationName,
    required this.scheduledArrival,
    required this.p10,
    required this.p50,
    required this.p90,
    this.bottleneckReason,
    this.congestionIndex = 0,
    this.weatherImpact,
    this.sectionalSpeedLimit = 130.0,
  });

  factory StationEta.fromJson(Map<String, dynamic> json) {
    return StationEta(
      stationCode: json['stationCode'] as String,
      stationName: json['stationName'] as String,
      scheduledArrival: DateTime.parse(json['scheduledArrival'] as String),
      p10: DateTime.parse(json['p10'] as String),
      p50: DateTime.parse(json['p50'] as String),
      p90: DateTime.parse(json['p90'] as String),
      bottleneckReason: json['bottleneckReason'] as String?,
      congestionIndex: json['congestionIndex'] as int? ?? 0,
      weatherImpact: json['weatherImpact'] as String?,
      sectionalSpeedLimit: (json['sectionalSpeedLimit'] as num? ?? 130.0)
          .toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationCode': stationCode,
      'stationName': stationName,
      'scheduledArrival': scheduledArrival.toIso8601String(),
      'p10': p10.toIso8601String(),
      'p50': p50.toIso8601String(),
      'p90': p90.toIso8601String(),
      'bottleneckReason': bottleneckReason,
      'congestionIndex': congestionIndex,
      'weatherImpact': weatherImpact,
      'sectionalSpeedLimit': sectionalSpeedLimit,
    };
  }
}
