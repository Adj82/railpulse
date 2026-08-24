import 'package:flutter/material.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/features/home/presentation/widgets/home_header.dart';
import 'package:railpulse/features/home/presentation/widgets/route_search_card.dart';
import 'package:railpulse/features/home/presentation/widgets/active_trip_widget.dart';
import 'package:railpulse/features/home/presentation/widgets/quick_services_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              const HomeHeader(),
              const SizedBox(height: 30),
              const RouteSearchCard(),
              const SizedBox(height: 25),
              _buildMLEtaBanner(),
              const SizedBox(height: 25),
              const ActiveTripWidget(),
              const SizedBox(height: 30),
              const Text(
                'Quick Services',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const QuickServicesGrid(),
              const SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMLEtaBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.sunsetGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sunsetGold.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, color: AppColors.sunsetGold, size: 18),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'SIH ML Insight: +12 min delay projected near Kanpur due to fog hold. Recalculated ETA: 04:45 PM',
              style: TextStyle(
                color: AppColors.sunsetGold,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
