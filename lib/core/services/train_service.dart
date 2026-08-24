import 'dart:async';
import 'dart:math';
import 'package:latlong2/latlong.dart';

enum SignalAspect { green, yellow, red, restricted }

class TrainTelemetry {
  final String trainNumber;
  final String trainName;
  final double speed;
  final double progress; 
  final String currentStation;
  final String nextStation;
  final int delayMinutes;
  final LatLng position;
  final List<LatLng> routePoints;
  
  // SIH PS26028 specific telemetry
  final SignalAspect signalStatus;
  final String? externalCondition; // e.g. "Heavy Fog"
  final String? recoveryBuffer; // e.g. "5 mins available"

  TrainTelemetry({
    required this.trainNumber,
    required this.trainName,
    required this.speed,
    required this.progress,
    required this.currentStation,
    required this.nextStation,
    required this.delayMinutes,
    required this.position,
    required this.routePoints,
    this.signalStatus = SignalAspect.green,
    this.externalCondition,
    this.recoveryBuffer,
  });
}

class TrainService {
  final _random = Random();
  
  final List<LatLng> _ndlsToKota = [
    const LatLng(28.6139, 77.2090), // NDLS
    const LatLng(28.2045, 77.0256), // Mathura
    const LatLng(27.4924, 77.6737), // Agra
    const LatLng(25.2138, 75.8648), // Kota
  ];

  Stream<TrainTelemetry> getLiveTelemetry(String trainNumber) async* {
    double progress = 0.0;
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      progress += 0.002;
      if (progress > 1.0) progress = 0.0;
      
      final pos = _interpolatePosition(_ndlsToKota, progress);
      
      // Simulate dynamic signal status based on progress
      SignalAspect signal = SignalAspect.green;
      if (progress > 0.28 && progress < 0.32) signal = SignalAspect.yellow;
      if (progress > 0.68 && progress < 0.72) signal = SignalAspect.red;

      yield TrainTelemetry(
        trainNumber: trainNumber,
        trainName: 'Rajdhani Express',
        speed: signal == SignalAspect.red ? 0.0 : (signal == SignalAspect.yellow ? 30.0 : 95.0 + _random.nextDouble() * 25),
        progress: progress,
        currentStation: progress < 0.3 ? 'New Delhi' : (progress < 0.7 ? 'Agra' : 'Kota'),
        nextStation: progress < 0.3 ? 'Agra' : (progress < 0.7 ? 'Kota' : 'Mumbai'),
        delayMinutes: 10 + _random.nextInt(10),
        position: pos,
        routePoints: _ndlsToKota,
        signalStatus: signal,
        externalCondition: progress > 0.5 ? 'Moderate Fog' : null,
        recoveryBuffer: '8 mins recovery potential',
      );
    }
  }

  LatLng _interpolatePosition(List<LatLng> points, double progress) {
    if (points.isEmpty) return const LatLng(0, 0);
    if (progress <= 0) return points.first;
    if (progress >= 1.0) return points.last;

    final double totalIndex = (points.length - 1) * progress;
    final int index = totalIndex.floor();
    final double fraction = totalIndex - index;

    final p1 = points[index];
    final p2 = points[index + 1];

    return LatLng(
      p1.latitude + (p2.latitude - p1.latitude) * fraction,
      p1.longitude + (p2.longitude - p1.longitude) * fraction,
    );
  }
}
