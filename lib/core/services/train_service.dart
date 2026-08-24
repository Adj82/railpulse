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

  // Demo corridor mirrors the SIH plan: Howrah - New Delhi via Grand Chord.
  final List<LatLng> _howrahToDelhi = [
    const LatLng(22.5958, 88.2636), // Howrah
    const LatLng(23.2324, 87.8615), // Barddhaman
    const LatLng(23.7957, 86.4304), // Dhanbad
    const LatLng(24.7914, 85.0002), // Gaya
    const LatLng(25.2739, 83.1197), // DDU
    const LatLng(25.4358, 81.8463), // Prayagraj
    const LatLng(26.4521, 80.3319), // Kanpur
    const LatLng(28.6412, 77.2180), // New Delhi
  ];

  Stream<TrainTelemetry> getLiveTelemetry(String trainNumber) async* {
    double progress = 0.0;
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      progress += 0.002;
      if (progress > 1.0) progress = 0.0;

      final pos = _interpolatePosition(_howrahToDelhi, progress);

      // Simulate dynamic signal status based on progress
      SignalAspect signal = SignalAspect.green;
      if (progress > 0.28 && progress < 0.32) signal = SignalAspect.yellow;
      if (progress > 0.68 && progress < 0.72) signal = SignalAspect.red;

      yield TrainTelemetry(
        trainNumber: trainNumber,
        trainName: 'Howrah Rajdhani Express',
        speed: signal == SignalAspect.red
            ? 0.0
            : (signal == SignalAspect.yellow
                  ? 30.0
                  : 95.0 + _random.nextDouble() * 25),
        progress: progress,
        currentStation: progress < 0.3
            ? 'Howrah'
            : (progress < 0.7 ? 'Gaya' : 'Kanpur Central'),
        nextStation: progress < 0.3
            ? 'Dhanbad'
            : (progress < 0.7 ? 'Prayagraj' : 'New Delhi'),
        delayMinutes: 10 + _random.nextInt(10),
        position: pos,
        routePoints: _howrahToDelhi,
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
