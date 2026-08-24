class LivePosition {
  final double lat;
  final double lng;
  final String lastStationCode;
  final DateTime lastUpdated;
  final int currentDelayMinutes;

  LivePosition({
    required this.lat,
    required this.lng,
    required this.lastStationCode,
    required this.lastUpdated,
    required this.currentDelayMinutes,
  });

  factory LivePosition.fromJson(Map<String, dynamic> json) {
    return LivePosition(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      lastStationCode: json['lastStationCode'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      currentDelayMinutes: json['currentDelayMinutes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'lastStationCode': lastStationCode,
      'lastUpdated': lastUpdated.toIso8601String(),
      'currentDelayMinutes': currentDelayMinutes,
    };
  }
}
