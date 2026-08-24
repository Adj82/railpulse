import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:railpulse/features/eta_tracking/data/models/eta_response.dart';
import 'package:railpulse/features/eta_tracking/data/models/live_position.dart';
import 'package:railpulse/features/eta_tracking/data/models/station_eta.dart';
import 'package:railpulse/core/config/app_config.dart';

abstract class EtaService {
  Future<EtaResponse> fetchEta(String trainNumber);
  Stream<LivePosition> watchLivePosition(String trainNumber);
}

enum ConnectionStatus { connected, reconnecting }

final connectionStatusProvider = StateProvider<ConnectionStatus>((ref) => ConnectionStatus.connected);

final etaServiceProvider = Provider<EtaService>((ref) {
  return MockEtaService();
});

final livePositionProvider = StreamProvider.family<LivePosition, String>((ref, trainNumber) {
  return ref.watch(etaServiceProvider).watchLivePosition(trainNumber);
});

class RealEtaService implements EtaService {
  final Ref _ref;
  RealEtaService(this._ref);

  @override
  Future<EtaResponse> fetchEta(String trainNumber) async {
    final response = await http.get(Uri.parse('${AppConfig.gatewayBaseUrl}/api/eta/$trainNumber'));
    if (response.statusCode == 200) {
      return EtaResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load ETA');
    }
  }

  @override
  Stream<LivePosition> watchLivePosition(String trainNumber) async* {
    int retryCount = 0;
    while (true) {
      try {
        final wsUrl = AppConfig.gatewayBaseUrl.replaceFirst('http', 'ws');
        final channel = WebSocketChannel.connect(Uri.parse('$wsUrl/ws/live/$trainNumber'));
        
        _ref.read(connectionStatusProvider.notifier).state = ConnectionStatus.connected;
        
        await for (final message in channel.stream) {
          retryCount = 0;
          yield LivePosition.fromJson(jsonDecode(message));
        }
      } catch (e) {
        // Continue to retry loop
      }
      
      _ref.read(connectionStatusProvider.notifier).state = ConnectionStatus.reconnecting;
      retryCount++;
      await Future.delayed(Duration(seconds: min(pow(2, retryCount).toInt(), 30)));
    }
  }
}

class MockEtaService implements EtaService {
  @override
  Future<EtaResponse> fetchEta(String trainNumber) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final now = DateTime.now();
    final stations = <StationEta>[];
    for (int i = 0; i < 10; i++) {
      final scheduled = now.add(Duration(minutes: (i + 1) * 45));
      final variance = 5 + (i * 2.5).toInt();
      stations.add(StationEta(
        stationCode: "STN${i + 1}",
        stationName: "Station ${i + 1}",
        scheduledArrival: scheduled,
        p10: scheduled.subtract(Duration(minutes: variance)),
        p50: scheduled.add(const Duration(minutes: 2)),
        p90: scheduled.add(Duration(minutes: variance + 5)),
      ));
    }
    return EtaResponse(
      trainNumber: trainNumber,
      livePosition: LivePosition(
        lat: 12.9716,
        lng: 77.5946,
        lastStationCode: "START",
        lastUpdated: now,
        currentDelayMinutes: 0,
      ),
      stations: stations,
    );
  }

  @override
  Stream<LivePosition> watchLivePosition(String trainNumber) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 4));
      yield LivePosition(
        lat: 12.9716,
        lng: 77.5946,
        lastStationCode: "MOCK",
        lastUpdated: DateTime.now(),
        currentDelayMinutes: 0,
      );
    }
  }
}
