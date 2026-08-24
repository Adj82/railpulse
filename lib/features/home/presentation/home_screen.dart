import 'package:flutter/material.dart';
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeader(),
                const SizedBox(height: 32),
                const RouteSearchCard(),
                const SizedBox(height: 32),
                const Text(
                  'Active Journey',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const ActiveTripWidget(),
                const SizedBox(height: 100), // Bottom Bar space
              ],
            ),
          ),
        ),
      ),
    );
  }
}
