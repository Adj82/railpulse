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
        
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60.0),
              child: CustomPaint(
                painter: _TimelinePainter(),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    _StationNode(
                      name: 'New Delhi (NDLS)',
                      scheduled: '16:25',
                      actual: '16:25',
                      status: StationStatus.passed,
                    ),
                    const SizedBox(height: 80),
                    _StationNode(
                      name: 'Kota Jn (KOTA)',
                      scheduled: '21:05',
                      actual: '21:20',
                      status: progress < 0.4 ? StationStatus.current : StationStatus.passed,
                      delayReason: 'Track Congestion Index: 82%',
                    ),
                    const SizedBox(height: 80),
                    _StationNode(
                      name: 'Ratlam Jn (RTM)',
                      scheduled: '00:15',
                      actual: '00:30',
                      status: progress >= 0.4 && progress < 0.6 ? StationStatus.current : (progress >= 0.6 ? StationStatus.passed : StationStatus.upcoming),
                    ),
                    const SizedBox(height: 80),
                    _StationNode(
                      name: 'Vadodara (BRC)',
                      scheduled: '03:20',
                      actual: '03:38',
                      status: progress >= 0.6 && progress < 0.8 ? StationStatus.current : (progress >= 0.8 ? StationStatus.passed : StationStatus.upcoming),
                    ),
                    const SizedBox(height: 80),
                    _StationNode(
                      name: 'Mumbai Central',
                      scheduled: '08:15',
                      actual: '08:35',
                      status: progress >= 0.8 ? StationStatus.current : StationStatus.upcoming,
                    ),
                  ],
                ),
              ),
            ),
            // The sliding train icon
            Positioned(
              left: 50,
              top: MediaQuery.of(context).size.height * progress * 0.7 + 50,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primaryCyan,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.primaryCyan, blurRadius: 10, spreadRadius: 2),
                  ],
                ),
                child: const Icon(LucideIcons.train, size: 16, color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum StationStatus { passed, current, upcoming }

class _StationNode extends StatelessWidget {
  final String name;
  final String scheduled;
  final String actual;
  final StationStatus status;
  final String? delayReason;

  const _StationNode({
    required this.name,
    required this.scheduled,
    required this.actual,
    required this.status,
    this.delayReason,
  });

  @override
  Widget build(BuildContext context) {
    bool isDelayed = scheduled != actual;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(-10, 8),
          child: _buildNodeIndicator(),
        ),
        const SizedBox(width: 25),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: status == StationStatus.passed ? AppColors.textSecondary : AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: status == StationStatus.current ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    scheduled,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      decoration: isDelayed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (isDelayed) ...[
                    const SizedBox(width: 8),
                    Text(
                      actual,
                      style: const TextStyle(
                        color: AppColors.primaryCyan,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
              if (delayReason != null) ...[
                const SizedBox(height: 10),
                _buildDelayInsight(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNodeIndicator() {
    switch (status) {
      case StationStatus.passed:
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black12),
          ),
        );
      case StationStatus.current:
        return _GlowingNode();
      case StationStatus.upcoming:
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26, width: 2),
          ),
        );
    }
  }

  Widget _buildDelayInsight() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.sunsetGold.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.sunsetGold.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.zap, color: AppColors.sunsetGold, size: 14),
              SizedBox(width: 6),
              Text(
                'ML DELAY PREDICTION',
                style: TextStyle(color: AppColors.sunsetGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            delayReason!,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 11),
          ),
          const SizedBox(height: 4),
          const Text(
            'Historical Fog Penalty: +8 mins | 3 trains ahead',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _GlowingNode extends StatefulWidget {
  @override
  State<_GlowingNode> createState() => _GlowingNodeState();
}

class _GlowingNodeState extends State<_GlowingNode> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ScaleTransition(
          scale: Tween(begin: 1.0, end: 2.0).animate(_controller),
          child: FadeTransition(
            opacity: Tween(begin: 0.5, end: 0.0).animate(_controller),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: AppColors.primaryCyan,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Container(
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            color: AppColors.primaryCyan,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: AppColors.primaryCyan, blurRadius: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
