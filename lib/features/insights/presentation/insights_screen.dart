import 'package:flutter/material.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/core/theme/app_theme.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.pageDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('BOTTLENECK RADAR')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildTrafficSummary(),
            const SizedBox(height: 32),
            const Text('Network Bottlenecks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _InsightCard(
              title: 'New Delhi (NDLS)',
              description: 'Platform 1-5 under maintenance. Expect 10min hold for all incoming trains.',
              icon: Icons.warning_amber_rounded,
              color: AppColors.error,
              tag: 'CRITICAL',
            ),
            const SizedBox(height: 16),
            _InsightCard(
              title: 'Kanpur Central',
              description: 'Heavy fog hold. AI predicts clearing in 45 mins. Dynamic ETA recalculated.',
              icon: Icons.cloudy_snowing,
              color: AppColors.warning,
              tag: 'WEATHER',
            ),
            const SizedBox(height: 32),
            const Text('Efficiency Optimization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _InsightCard(
              title: 'Route Optimizer',
              description: 'Taking the Metro from NDLS to Shivaji Stadium will save you 15 mins today.',
              icon: Icons.auto_awesome,
              color: AppColors.primary,
              tag: 'SUGGESTION',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: AppColors.secondary.withOpacity(0.3), blurRadius: 20)],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Live Network Status', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Icon(Icons.online_prediction, color: AppColors.success),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric('92%', 'On-Time'),
              _buildMetric('14', 'Alerts'),
              _buildMetric('1.2k', 'Trains'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String val, String label) {
    return Column(
      children: [
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String tag;

  const _InsightCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(tag, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }
}
