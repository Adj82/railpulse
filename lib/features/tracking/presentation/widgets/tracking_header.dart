import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/shared/widgets/glass_card.dart';

class TrackingHeader extends StatelessWidget {
  const TrackingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      hasGlow: true,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '12951 • RAJDHANI EXP',
                    style: TextStyle(
                      color: AppColors.primaryCyan,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NDLS to Mumbai Central',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
              _buildDelayBadge(),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(LucideIcons.gauge, '110 km/h', 'Current Speed'),
              _buildStatItem(LucideIcons.mapPin, 'KOTA JN', 'Next Station'),
              _buildStatItem(LucideIcons.clock, '15 mins', 'ML Delay'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDelayBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.sunsetGold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.sunsetGold.withOpacity(0.5)),
      ),
      child: const Text(
        '+15m Delay',
        style: TextStyle(color: AppColors.sunsetGold, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryCyan, size: 20),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
      ],
    );
  }
}
