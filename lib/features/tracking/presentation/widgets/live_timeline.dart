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
        final progress = state is TrackingLoaded ? state.telemetry.progress : 0.2;
        
        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60.0),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    children: [
                      _StationNode(name: 'New Delhi (NDLS)', time: '16:25', status: StationStatus.passed),
                      _buildLine(),
                      _StationNode(
                        name: 'Kota Jn (KOTA)', 
                        time: '21:20', 
                        status: progress < 0.4 ? StationStatus.current : StationStatus.passed,
                        isDelayed: true,
                      ),
                      _buildLine(),
                      _StationNode(
                        name: 'Ratlam Jn (RTM)', 
                        time: '00:30', 
                        status: progress >= 0.4 && progress < 0.6 ? StationStatus.current : (progress >= 0.6 ? StationStatus.passed : StationStatus.upcoming),
                      ),
                      _buildLine(),
                      _StationNode(
                        name: 'Mumbai Central', 
                        time: '08:35', 
                        status: progress >= 0.8 ? StationStatus.current : StationStatus.upcoming,
                      ),
                    ],
                  ),
                ),
                // Optimized train icon position mapping
                Positioned(
                  left: 51,
                  top: 40 + (progress * (constraints.maxHeight - 120)).clamp(0, constraints.maxHeight - 100),
                  child: _MovingTrainIcon(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLine() => Container(
    margin: const EdgeInsets.only(left: 10),
    width: 2,
    height: 80,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.black12, Colors.black.withOpacity(0.02)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  );
}

enum StationStatus { passed, current, upcoming }

class _StationNode extends StatelessWidget {
  final String name;
  final String time;
  final StationStatus status;
  final bool isDelayed;

  const _StationNode({required this.name, required this.time, required this.status, this.isDelayed = false});

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
              Text(name, style: TextStyle(
                fontWeight: status == StationStatus.current ? FontWeight.bold : FontWeight.normal,
                color: status == StationStatus.upcoming ? AppColors.textSecondary : AppColors.textPrimary,
                fontSize: 16,
              )),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time, size: 12, color: isDelayed ? AppColors.warning : AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(time, style: TextStyle(
                    color: isDelayed ? AppColors.warning : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: isDelayed ? FontWeight.bold : FontWeight.normal,
                  )),
                  if (isDelayed) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: const Text('ML: +15m', style: TextStyle(color: AppColors.warning, fontSize: 10, fontWeight: FontWeight.bold)),
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
        return const Icon(Icons.check_circle, color: AppColors.success, size: 22);
      case StationStatus.current:
        return Container(
          width: 22, height: 22,
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), shape: BoxShape.circle),
          child: const Center(child: Icon(Icons.circle, color: AppColors.primary, size: 12)),
        );
      case StationStatus.upcoming:
        return Container(
          width: 22, height: 22,
          decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 2), shape: BoxShape.circle),
        );
    }
  }
}

class _MovingTrainIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle, boxShadow: [
        BoxShadow(color: AppColors.secondary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
      ]),
      child: const Icon(LucideIcons.train, color: Colors.white, size: 14),
    );
  }
}
