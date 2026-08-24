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
        appBar: AppBar(title: const Text('AI INSIGHTS')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _InsightCard(
              title: 'Congestion Alert',
              description: 'AI predicts a 15-minute delay on the Blue Line due to heavy traffic at New Delhi.',
              icon: Icons.radar,
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            _InsightCard(
              title: 'Weather Impact',
              description: 'Heavy fog detected near Kanpur. ETA recalculated (+12 mins).',
              icon: Icons.cloudy_snowing,
              color: AppColors.accentBlue,
            ),
            const SizedBox(height: 20),
            _InsightCard(
              title: 'Efficiency Index',
              description: 'Your route today is 12% faster than last week.',
              icon: Icons.speed,
              color: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _InsightCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.secondary.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
