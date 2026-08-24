import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/core/theme/app_theme.dart';
import 'package:railpulse/features/home/presentation/widgets/home_header.dart';
import 'package:railpulse/features/home/presentation/widgets/route_search_card.dart';
import 'package:railpulse/features/home/presentation/widgets/active_trip_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.pageDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              const HomeHeader(),
              const SizedBox(height: 32),
              _buildWeatherGlance(),
              const SizedBox(height: 24),
              const RouteSearchCard(),
              const SizedBox(height: 32),
              const _SectionHeader(title: 'Active Tracking'),
              const SizedBox(height: 16),
              const ActiveTripWidget(),
              const SizedBox(height: 32),
              const _SectionHeader(title: 'Nearby Hubs'),
              const SizedBox(height: 16),
              _buildNearbyStations(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherGlance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accentBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentBlue.withOpacity(0.2)),
      ),
      child: const Row(
        children: [
          Icon(LucideIcons.cloudFog, color: AppColors.accentBlue, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Foggy Conditions near Kanpur', 
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentBlue)),
                Text('Slight delays expected on North-bound routes.', 
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyStations() {
    final List<Map<String, String>> hubs = [
      {'name': 'New Delhi', 'dist': '2.4 km', 'status': 'Crowded'},
      {'name': 'Hazrat Nizamuddin', 'dist': '5.1 km', 'status': 'Normal'},
    ];

    return Row(
      children: hubs.map((hub) => Expanded(
        child: Container(
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hub['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(hub['dist']!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hub['status'] == 'Crowded' ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(hub['status']!, 
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, 
                    color: hub['status'] == 'Crowded' ? AppColors.error : AppColors.success)),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('See All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
