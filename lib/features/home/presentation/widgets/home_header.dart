import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primaryCyan,
                  child: Icon(LucideIcons.user, color: Colors.black),
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.neonEmerald,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.backgroundDeep, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonEmerald.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning,',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Traveler',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        _NotificationBell(),
      ],
    );
  }
}

class _NotificationBell extends StatefulWidget {
  @override
  State<_NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<_NotificationBell> with SingleTickerProviderStateMixin {
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
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(LucideIcons.bell, color: AppColors.textPrimary, size: 28),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: ScaleTransition(
            scale: Tween(begin: 0.8, end: 1.2).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            ),
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.primaryCyan,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
