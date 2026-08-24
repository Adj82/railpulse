class StationEta {
  final String stationCode;
  final String stationName;
  final DateTime scheduledArrival;
  final DateTime p10;
  final DateTime p50;
  final DateTime p90;

  StationEta({
    required this.stationCode,
    required this.stationName,
    required this.scheduledArrival,
    required this.p10,
    required this.p50,
    required this.p90,
  });

  factory StationEta.fromJson(Map<String, dynamic> json) {
    return StationEta(
      stationCode: json['stationCode'] as String,
      stationName: json['stationName'] as String,
      scheduledArrival: DateTime.parse(json['scheduledArrival'] as String),
      p10: DateTime.parse(json['p10'] as String),
      p50: DateTime.parse(json['p50'] as String),
      p90: DateTime.parse(json['p90'] as String),
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
    };
  }
}
