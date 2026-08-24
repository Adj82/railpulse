import 'live_position.dart';
import 'station_eta.dart';

class EtaResponse {
  final String trainNumber;
  final LivePosition livePosition;
  final List<StationEta> stations;

  EtaResponse({
    required this.trainNumber,
    required this.livePosition,
    required this.stations,
  });

  factory EtaResponse.fromJson(Map<String, dynamic> json) {
    return EtaResponse(
      trainNumber: json['trainNumber'] as String,
      livePosition: LivePosition.fromJson(json['livePosition'] as Map<String, dynamic>),
      stations: (json['stations'] as List<dynamic>)
          .map((e) => StationEta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trainNumber': trainNumber,
      'livePosition': livePosition.toJson(),
      'stations': stations.map((e) => e.toJson()).toList(),
    };
  }
}
