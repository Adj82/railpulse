import 'package:flutter_test/flutter_test.dart';
import 'package:railpulse/features/eta_tracking/data/models/eta_response.dart';
import 'package:railpulse/features/eta_tracking/data/services/eta_service.dart';

void main() {
  test('demo prediction provides ordered confidence intervals', () async {
    final EtaResponse response = await MockEtaService().fetchEta('12345');
    expect(response.stations, isNotEmpty);
    for (final station in response.stations) {
      expect(
        station.p10.isAfter(station.scheduledArrival) ||
            station.p10.isAtSameMomentAs(station.scheduledArrival),
        isTrue,
      );
      expect(
        station.p50.isAfter(station.p10) ||
            station.p50.isAtSameMomentAs(station.p10),
        isTrue,
      );
      expect(
        station.p90.isAfter(station.p50) ||
            station.p90.isAtSameMomentAs(station.p50),
        isTrue,
      );
    }
  });
}
