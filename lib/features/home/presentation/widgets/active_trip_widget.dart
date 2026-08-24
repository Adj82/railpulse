import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/features/tracking/presentation/bloc/tracking_bloc.dart';

class ActiveTripWidget extends StatelessWidget {
  const ActiveTripWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        final telemetry = state is TrackingLoaded ? state.telemetry : null;
        
        return InkWell(
          onTap: () => context.push('/tracking'),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: AppColors.secondary.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.train, color: AppColors.success, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '12951 • Rajdhani Express',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        telemetry != null 
                          ? 'Approaching ${telemetry.nextStation} • ${telemetry.speed.toInt()} km/h'
                          : 'Live Tracking Active',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
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
}
