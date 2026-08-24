import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_theme.dart';
import 'package:railpulse/features/tracking/presentation/widgets/tracking_header.dart';
import 'package:railpulse/features/tracking/presentation/widgets/live_timeline.dart';

class TrainTrackingScreen extends StatelessWidget {
  const TrainTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.pageDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('LIVE TRACKING')),
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: TrackingHeader(),
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
