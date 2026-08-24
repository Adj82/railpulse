import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/core/services/train_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:railpulse/features/tracking/presentation/bloc/tracking_bloc.dart';

class TrackingHeader extends StatelessWidget {
  const TrackingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        final telemetry = state is TrackingLoaded ? state.telemetry : null;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
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
                        Text(
                          telemetry?.trainName ?? '12951 • RAJDHANI EXP',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'NDLS → Mumbai Central',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildSignalIndicator(
                    telemetry?.signalStatus ?? SignalAspect.green,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(
                    LucideIcons.gauge,
                    '${telemetry?.speed.toInt() ?? 0} km/h',
                    'Current Speed',
                  ),
                  _buildStat(
                    LucideIcons.mapPin,
                    telemetry?.nextStation ?? 'KOTA JN',
                    'Next Stop',
                  ),
                  _buildStat(
                    LucideIcons.clock,
                    '+${telemetry?.delayMinutes ?? 15}m Delay',
                    'ML Prediction',
                  ),
                ],
              ),
              if (telemetry?.externalCondition != null) ...[
                const SizedBox(height: 16),
                _buildWeatherBanner(telemetry!.externalCondition!),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignalIndicator(SignalAspect signal) {
    Color color;
    String label;
    switch (signal) {
      case SignalAspect.green:
        color = AppColors.success;
        label = 'Clear';
        break;
      case SignalAspect.yellow:
        color = AppColors.warning;
        label = 'Restricted';
        break;
      case SignalAspect.red:
        color = AppColors.error;
        label = 'Halt';
        break;
      case SignalAspect.restricted:
        color = Colors.orange;
        label = 'Slow';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherBanner(String condition) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.accentBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.cloudFog,
            size: 16,
            color: AppColors.accentBlue,
          ),
          const SizedBox(width: 10),
          Text(
            'External Factor: $condition detected',
            style: const TextStyle(
              color: AppColors.accentBlue,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String val, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 8),
        Text(
          val,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
        ),
      ],
    );
  }
}
