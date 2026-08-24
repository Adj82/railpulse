import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/navigation/navigation_bloc.dart';
import 'package:railpulse/core/services/train_service.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/core/theme/app_theme.dart';
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
        BlocProvider(
          create: (context) =>
              TrackingBloc(TrainService())..add(const StartTracking('12951')),
        ),
        BlocProvider(create: (context) => SearchBloc()),
      ],
      child: Container(
        decoration: AppTheme.pageDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: child,
          bottomNavigationBar: const _ModernBottomBar(),
        ),
      ),
    );
  }
}

class _ModernBottomBar extends StatelessWidget {
  const _ModernBottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: LucideIcons.home,
                label: 'Home',
                isSelected: state.index == 0,
                onTap: () {
                  context.read<NavigationBloc>().add(
                    const NavigationTabChanged(0),
                  );
                  context.go('/');
                },
              ),
              _NavItem(
                icon: LucideIcons.map,
                label: 'Map',
                isSelected: state.index == 1,
                onTap: () {
                  context.read<NavigationBloc>().add(
                    const NavigationTabChanged(1),
                  );
                  context.go('/map');
                },
              ),
              _NavItem(
                icon: LucideIcons.activity,
                label: 'Tracker',
                isSelected: state.index == 2,
                onTap: () {
                  context.read<NavigationBloc>().add(
                    const NavigationTabChanged(2),
                  );
                  context.go('/tracker');
                },
              ),
              _NavItem(
                icon: LucideIcons.barChart3,
                label: 'Insights',
                isSelected: state.index == 3,
                onTap: () {
                  context.read<NavigationBloc>().add(
                    const NavigationTabChanged(3),
                  );
                  context.go('/insights');
                },
              ),
            ],
          );
        },
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
