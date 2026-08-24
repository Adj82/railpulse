import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/shared/widgets/glass_card.dart';
import 'package:railpulse/features/eta_tracking/data/models/eta_response.dart';
import 'package:railpulse/features/eta_tracking/data/models/live_position.dart';
import 'package:railpulse/features/eta_tracking/data/models/station_eta.dart';
import 'package:railpulse/features/eta_tracking/data/services/eta_service.dart';

class EtaResultScreen extends ConsumerWidget {
  final EtaResponse etaResponse;

  const EtaResultScreen({super.key, required this.etaResponse});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final livePositionAsync = ref.watch(livePositionProvider(etaResponse.trainNumber));
    final connectionStatus = ref.watch(connectionStatusProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Train ${etaResponse.trainNumber}',
          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (connectionStatus == ConnectionStatus.reconnecting)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.softPink),
                ),
              ),
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.paleBlue,
              Colors.white,
              AppColors.lightPink,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LivePositionHeader(
                  initialPosition: etaResponse.livePosition,
                  asyncPosition: livePositionAsync,
                  isReconnecting: connectionStatus == ConnectionStatus.reconnecting,
                ),
                const SizedBox(height: 20),
                const Text(
                  'ETA Projections (P10/P50/P90)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 15),
                GlassCard(
                  padding: const EdgeInsets.only(right: 20, left: 10, top: 20, bottom: 20),
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: _EtaChart(stations: etaResponse.stations),
                  ),
                ),
                const SizedBox(height: 100), // Space for bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LivePositionHeader extends StatelessWidget {
  final LivePosition initialPosition;
  final AsyncValue<LivePosition> asyncPosition;
  final bool isReconnecting;

  const _LivePositionHeader({
    required this.initialPosition,
    required this.asyncPosition,
    this.isReconnecting = false,
  });

  Color _getDelayColor(int minutes) {
    if (minutes == 0) return AppColors.softPurple;
    if (minutes < 15) return AppColors.softPink;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final position = asyncPosition.valueOrNull ?? initialPosition;
    final timeStr = DateFormat('HH:mm:ss').format(position.lastUpdated);
    final delayColor = _getDelayColor(position.currentDelayMinutes);

    return GlassCard(
      hasGlow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Last Station: ${position.lastStationCode}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              if (isReconnecting) ...[
                const SizedBox(width: 8),
                const Text(
                  '(Reconnecting...)',
                  style: TextStyle(color: AppColors.softPink, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
          Text(
            'as of $timeStr',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: delayColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: delayColor.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, color: delayColor),
                const SizedBox(width: 10),
                Text(
                  'Delay: ${position.currentDelayMinutes} mins',
                  style: TextStyle(
                    color: delayColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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

class _EtaChart extends StatelessWidget {
  final List<StationEta> stations;

  const _EtaChart({required this.stations});

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) return const Center(child: Text('No data'));

    final baseTime = stations.first.scheduledArrival;

    double toMinutes(DateTime time) {
      return time.difference(baseTime).inMinutes.toDouble();
    }

    final p10Spots = <FlSpot>[];
    final p50Spots = <FlSpot>[];
    final p90Spots = <FlSpot>[];

    for (int i = 0; i < stations.length; i++) {
      final s = stations[i];
      p10Spots.add(FlSpot(i.toDouble(), toMinutes(s.p10)));
      p50Spots.add(FlSpot(i.toDouble(), toMinutes(s.p50)));
      p90Spots.add(FlSpot(i.toDouble(), toMinutes(s.p90)));
    }

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: p10Spots,
            isCurved: true,
            color: AppColors.softPurple.withOpacity(0.3),
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: p90Spots,
            isCurved: true,
            color: AppColors.softPink.withOpacity(0.3),
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: p50Spots,
            isCurved: true,
            color: AppColors.softPurple,
            barWidth: 4,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: AppColors.softPurple,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
          ),
        ],
        betweenBarsData: [
          BetweenBarsData(
            fromIndex: 0,
            toIndex: 1,
            color: AppColors.softPurple.withOpacity(0.1),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= stations.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Transform.rotate(
                    angle: -0.8,
                    child: Text(
                      stations[index].stationName,
                      style: const TextStyle(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                final time = baseTime.add(Duration(minutes: value.toInt()));
                return Text(
                  DateFormat('HH:mm').format(time),
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.black.withOpacity(0.05),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: AppColors.softPurple,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final time = baseTime.add(Duration(minutes: spot.y.toInt()));
                return LineTooltipItem(
                  DateFormat('HH:mm').format(time),
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
