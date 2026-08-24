import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/core/theme/app_theme.dart';
import 'package:railpulse/features/eta_tracking/data/models/eta_response.dart';
import 'package:railpulse/features/eta_tracking/data/services/eta_service.dart';

class EtaResultScreen extends ConsumerWidget {
  final EtaResponse etaResponse;
  const EtaResultScreen({super.key, required this.etaResponse});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: AppTheme.pageDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('Train ${etaResponse.trainNumber}')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatusHeader(response: etaResponse),
              const SizedBox(height: 32),
              const Text('Delay Variance Chart (ML)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Minutes of predicted delay vs Scheduled', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 16),
              Container(
                height: 350,
                padding: const EdgeInsets.fromLTRB(16, 48, 32, 16),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
                ),
                child: _LineChart(response: etaResponse),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  final EtaResponse response;
  const _StatusHeader({required this.response});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.location_on, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Last Station: ${response.livePosition.lastStationCode}', 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 14, color: AppColors.error),
                    const SizedBox(width: 6),
                    Text('Delay: ${response.livePosition.currentDelayMinutes} mins', 
                      style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final EtaResponse response;
  const _LineChart({required this.response});

  @override
  Widget build(BuildContext context) {
    final spots = response.stations.asMap().entries.map((e) {
      final delay = e.value.p50.difference(e.value.scheduledArrival).inMinutes.toDouble();
      return FlSpot(e.key.toDouble(), delay > 0 ? delay : 0);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.black.withOpacity(0.05), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text('${value.toInt()}m', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= response.stations.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Text(
                      response.stations[index].stationCode,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 3,
                strokeColor: AppColors.primary,
              ),
            ),
            belowBarData: BarAreaData(
              show: true, 
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.3), AppColors.primary.withOpacity(0.0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: AppColors.secondary,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toInt()} min delay',
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
