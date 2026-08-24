import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:railpulse/core/config/app_config.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/core/theme/app_theme.dart';
import 'package:railpulse/features/eta_tracking/data/models/eta_response.dart';
import 'package:railpulse/features/eta_tracking/data/models/live_position.dart';
import 'package:railpulse/features/eta_tracking/data/models/station_eta.dart';
import 'package:railpulse/features/eta_tracking/data/services/eta_service.dart';

class EtaResultScreen extends ConsumerWidget {
  final EtaResponse etaResponse;
  const EtaResultScreen({super.key, required this.etaResponse});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(livePositionProvider(etaResponse.trainNumber));
    final live = position.valueOrNull ?? etaResponse.livePosition;
    return Container(
      decoration: AppTheme.pageDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('Train ${etaResponse.trainNumber}')),
        body: RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(livePositionProvider(etaResponse.trainNumber)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 112),
            children: [
              _StatusHeader(live: live),
              const SizedBox(height: 18),
              _ConfidenceCard(stations: etaResponse.stations),
              const SizedBox(height: 24),
              const Text(
                'Forecast across your journey',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'The shaded band is the model\'s 80% arrival window. It updates after each new train event.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 255,
                child: _ForecastChart(stations: etaResponse.stations),
              ),
              const SizedBox(height: 24),
              const Text(
                'Downstream arrivals',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              ...etaResponse.stations.map(
                (station) => _StationForecast(station: station),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  final LivePosition live;
  const _StatusHeader({required this.live});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.secondary,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.train_rounded, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Live journey forecast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            _Pill(
              text: 'LIVE',
              color: AppColors.success,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Last confirmed at ${live.lastStationCode}',
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          '${live.currentDelayMinutes >= 0 ? '+' : ''}${live.currentDelayMinutes} min current delay',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Updated ${DateFormat('hh:mm a').format(live.lastUpdated)}',
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    ),
  );
}

class _ConfidenceCard extends StatelessWidget {
  final List<StationEta> stations;
  const _ConfidenceCard({required this.stations});
  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) return const SizedBox();
    final next = stations.first;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 18),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: AppColors.primary,
            size: 30,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next: ${next.stationName}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  '${DateFormat('hh:mm a').format(next.p10)} - ${DateFormat('hh:mm a').format(next.p90)}',
                  style: const TextStyle(
                    fontSize: 17,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  '80% confidence window',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ForecastChart extends StatelessWidget {
  final List<StationEta> stations;
  const _ForecastChart({required this.stations});
  double _delay(DateTime time, StationEta s) =>
      time.difference(s.scheduledArrival).inMinutes.toDouble();
  @override
  Widget build(BuildContext context) {
    final low = <FlSpot>[];
    final median = <FlSpot>[];
    final high = <FlSpot>[];
    for (var i = 0; i < stations.length; i++) {
      final s = stations[i];
      low.add(FlSpot(i.toDouble(), _delay(s.p10, s)));
      median.add(FlSpot(i.toDouble(), _delay(s.p50, s)));
      high.add(FlSpot(i.toDouble(), _delay(s.p90, s)));
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: Colors.black.withOpacity(.06)),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 34,
                getTitlesWidget: (v, _) => Text(
                  '${v.toInt()}m',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (v, _) {
                  final i = v.toInt();
                  return i < 0 || i >= stations.length
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            stations[i].stationCode,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: low,
              isCurved: true,
              color: AppColors.primary.withOpacity(.32),
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: high,
              isCurved: true,
              color: AppColors.primary.withOpacity(.32),
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withOpacity(.12),
              ),
            ),
            LineChartBarData(
              spots: median,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _StationForecast extends StatelessWidget {
  final StationEta station;
  const _StationForecast({required this.station});
  @override
  Widget build(BuildContext context) {
    final width = station.p90.difference(station.p10).inMinutes;
    final level = station.congestionIndex >= 65
        ? 'High'
        : station.congestionIndex >= 40
        ? 'Moderate'
        : 'Low';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.stationName,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      station.stationCode,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('hh:mm a').format(station.p50),
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.unfold_more_rounded,
                size: 15,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${DateFormat('hh:mm a').format(station.p10)} - ${DateFormat('hh:mm a').format(next90(station))} ($width min band)',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              _Pill(
                text: '$level congestion',
                color: level == 'High' ? AppColors.error : AppColors.warning,
              ),
            ],
          ),
          if (station.bottleneckReason != null || station.weatherImpact != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                [
                  station.bottleneckReason,
                  station.weatherImpact,
                ].whereType<String>().join(' • '),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  DateTime next90(StationEta s) => s.p90;
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill({required this.text, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(.18),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800),
    ),
  );
}
