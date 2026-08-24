import 'dart:async';
import 'dart:math';

class TrainTelemetry {
  final double speed;
  final double progress; // 0.0 to 1.0 along the route
  final String currentStation;
  final String nextStation;
  final int delayMinutes;

  TrainTelemetry({
    required this.speed,
    required this.progress,
    required this.currentStation,
    required this.nextStation,
    required this.delayMinutes,
  });
}

class TrainService {
  final _random = Random();
  
  Stream<TrainTelemetry> getLiveTelemetry(String trainNumber) async* {
    double progress = 0.2;
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      progress += 0.005;
      if (progress > 1.0) progress = 0.0;
      
      yield TrainTelemetry(
        speed: 100.0 + _random.nextDouble() * 20,
        progress: progress,
        currentStation: 'New Delhi',
        nextStation: 'Kota Jn',
        delayMinutes: 12 + _random.nextInt(5),
      );
    }
  }
}
