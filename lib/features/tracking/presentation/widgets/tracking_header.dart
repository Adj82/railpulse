import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_colors.dart';

class TrackingHeader extends StatelessWidget {
  const TrackingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: AppColors.secondary.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '12951 • RAJDHANI EXP',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'NDLS → Mumbai Central',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildDelayBadge(),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(LucideIcons.gauge, '110 km/h', 'Speed'),
              _buildStat(LucideIcons.mapPin, 'KOTA JN', 'Next'),
              _buildStat(LucideIcons.clock, '15m Delay', 'ML Status'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDelayBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text('Delayed', style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildStat(IconData icon, String val, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 8),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}
