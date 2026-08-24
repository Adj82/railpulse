import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/features/tracking/presentation/widgets/tracking_header.dart';
import 'package:railpulse/features/tracking/presentation/widgets/live_timeline.dart';
import 'package:railpulse/features/tracking/presentation/widgets/tracking_toggle_bar.dart';

class TrainTrackingScreen extends StatelessWidget {
  const TrainTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.paleBlue,
              Colors.white,
              AppColors.lightPink,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(LucideIcons.chevronLeft, color: AppColors.textPrimary),
                    ),
                    const Text(
                      'Live Tracking',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.share2, color: AppColors.textPrimary, size: 20),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TrackingHeader(),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TrackingToggleBar(),
              ),
              const Expanded(
                child: LiveTimeline(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
