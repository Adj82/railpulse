import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/features/tracking/presentation/bloc/tracking_bloc.dart';
import 'package:railpulse/shared/widgets/glass_card.dart';

class ActiveTripWidget extends StatefulWidget {
  const ActiveTripWidget({super.key});

  @override
  State<ActiveTripWidget> createState() => _ActiveTripWidgetState();
}

class _ActiveTripWidgetState extends State<ActiveTripWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        final telemetry = state is TrackingLoaded ? state.telemetry : null;
        
        return GestureDetector(
          onTap: () => context.push('/tracking'),
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                _buildSpeedIndicator(telemetry?.speed.toInt() ?? 0),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '12951 - RAJDHANI EXPRESS',
                        style: TextStyle(
                          color: AppColors.primaryCyan,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('NDLS', style: TextStyle(fontWeight: FontWeight.bold)),
                          const Icon(Icons.arrow_right_alt, color: AppColors.textSecondary, size: 16),
                          const Text('MUMBAI CENTRAL', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        telemetry != null 
                          ? 'On track • Approaching ${telemetry.nextStation}'
                          : 'Loading live status...',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevronRight, color: AppColors.textSecondary),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpeedIndicator(int speed) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ScaleTransition(
          scale: Tween(begin: 1.0, end: 1.3).animate(
            CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
          ),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.neonEmerald.withOpacity(0.3), width: 2),
            ),
          ),
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.neonEmerald.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$speed',
                style: const TextStyle(
                  color: AppColors.neonEmerald,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Text(
                'km/h',
                style: TextStyle(
                  color: AppColors.neonEmerald,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
