import 'package:flutter/material.dart';
import 'package:railpulse/shared/widgets/glass_card.dart';
import 'package:railpulse/core/theme/app_colors.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.paleBlue,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'SIH AI Insights',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              const GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.radar, color: AppColors.sunsetGold),
                        SizedBox(width: 10),
                        Text('Delay Radar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      'AI predicts a 15-minute delay on the Blue Line due to technical maintenance at Rajiv Chowk.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const GlassCard(
                hasGlow: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bottleneck Visualizer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 15),
                    // Simple bar chart simulation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _Bar(height: 40, label: '8 AM'),
                        _Bar(height: 100, label: '9 AM', color: AppColors.sunsetGold),
                        _Bar(height: 80, label: '10 AM'),
                        _Bar(height: 50, label: '11 AM'),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final String label;
  final Color color;

  const _Bar({required this.height, required this.label, this.color = AppColors.primaryCyan});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          width: 30,
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
