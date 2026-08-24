import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/navigation/navigation_bloc.dart';
import 'package:railpulse/core/services/booking_service.dart';
import 'package:railpulse/core/services/train_service.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:railpulse/features/home/presentation/bloc/search_bloc.dart';
import 'package:railpulse/features/tracking/presentation/bloc/tracking_bloc.dart';

class NavigationShell extends StatelessWidget {
  final Widget child;

  const NavigationShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationBloc()),
        BlocProvider(create: (context) => TrackingBloc(TrainService())..add(const StartTracking('12951'))),
        BlocProvider(create: (context) => BookingBloc(BookingService())..add(LoadBookingData())),
        BlocProvider(create: (context) => SearchBloc()),
      ],
      child: Scaffold(
        extendBody: true, // Crucial for floating nav bar
        body: child,
        bottomNavigationBar: const _GlassBottomBar(),
      ),
    );
  }
}

class _GlassBottomBar extends StatelessWidget {
  const _GlassBottomBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: BlocBuilder<NavigationBloc, NavigationState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: LucideIcons.home,
                      label: 'Home',
                      isSelected: state.index == 0,
                      onTap: () {
                        context.read<NavigationBloc>().add(const NavigationTabChanged(0));
                        context.go('/');
                      },
                    ),
                    _NavItem(
                      icon: LucideIcons.map,
                      label: 'Network',
                      isSelected: state.index == 1,
                      onTap: () {
                        context.read<NavigationBloc>().add(const NavigationTabChanged(1));
                        context.go('/map');
                      },
                    ),
                    _NavItem(
                      icon: LucideIcons.ticket,
                      label: 'Booking',
                      isSelected: state.index == 2,
                      onTap: () {
                        context.read<NavigationBloc>().add(const NavigationTabChanged(2));
                        context.go('/booking');
                      },
                    ),
                    _NavItem(
                      icon: LucideIcons.barChart3,
                      label: 'Insights',
                      isSelected: state.index == 3,
                      onTap: () {
                        context.read<NavigationBloc>().add(const NavigationTabChanged(3));
                        context.go('/insights');
                      },
                    ),
                    _NavItem(
                      icon: LucideIcons.activity,
                      label: 'Tracker',
                      isSelected: state.index == 4,
                      onTap: () {
                        context.read<NavigationBloc>().add(const NavigationTabChanged(4));
                        context.go('/tracker');
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryCyan.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.primaryCyan : AppColors.textSecondary,
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primaryCyan : AppColors.textSecondary,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
