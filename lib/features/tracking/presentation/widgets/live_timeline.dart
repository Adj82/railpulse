import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/features/tracking/presentation/bloc/tracking_bloc.dart';

class LiveTimeline extends StatelessWidget {
  const LiveTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        final progress = state is TrackingLoaded
            ? state.telemetry.progress
            : 0.0;

        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60.0),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    children: [
                      _StationNode(
                        name: 'New Delhi (NDLS)',
                        time: '16:25',
                        status: progress > 0.05
                            ? StationStatus.passed
                            : StationStatus.current,
                      ),
                      _buildLine(isActive: progress > 0.1),
                      _StationNode(
                        name: 'Mathura Jn',
                        time: '18:10',
                        status: progress < 0.25
                            ? StationStatus.upcoming
                            : (progress < 0.35
                                  ? StationStatus.current
                                  : StationStatus.passed),
                      ),
                      _buildLine(isActive: progress > 0.4),
                      _StationNode(
                        name: 'Agra Cantt',
                        time: '19:15',
                        status: progress < 0.5
                            ? StationStatus.upcoming
                            : (progress < 0.6
                                  ? StationStatus.current
                                  : StationStatus.passed),
                        isDelayed: true,
                      ),
                      _buildLine(isActive: progress > 0.7),
                      _StationNode(
                        name: 'Kota Jn (KOTA)',
                        time: '21:20',
                        status: progress < 0.9
                            ? StationStatus.upcoming
                            : StationStatus.current,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 51,
                  top: (55 + (progress * 480).clamp(0, constraints.maxHeight - 150)).toDouble(),
                  child: _MovingTrainIcon(
                    speed: state is TrackingLoaded
                        ? state.telemetry.speed.toInt()
                        : 0,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLine({bool isActive = false}) => Container(
    margin: const EdgeInsets.only(left: 10),
    width: 3,
    height: 80,
    decoration: BoxDecoration(
      color: isActive
          ? AppColors.success.withOpacity(0.3)
          : Colors.black.withOpacity(0.05),
      borderRadius: BorderRadius.circular(2),
    ),
  );
}

enum StationStatus { passed, current, upcoming }

class _StationNode extends StatelessWidget {
  final String name;
  final String time;
  final StationStatus status;
  final bool isDelayed;

  const _StationNode({
    required this.name,
    required this.time,
    required this.status,
    this.isDelayed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildIndicator(),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: status == StationStatus.current
                      ? FontWeight.w900
                      : FontWeight.bold,
                  color: status == StationStatus.upcoming
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      color: isDelayed
                          ? AppColors.error
                          : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: isDelayed
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  if (status == StationStatus.current) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator() {
    switch (status) {
      case StationStatus.passed:
        return const Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 24,
        );
      case StationStatus.current:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.circle, color: AppColors.primary, size: 14),
          ),
        );
      case StationStatus.upcoming:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 3),
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        );
    }
  }
}

class _MovingTrainIcon extends StatelessWidget {
  final int speed;
  const _MovingTrainIcon({required this.speed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(LucideIcons.train, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$speed',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
