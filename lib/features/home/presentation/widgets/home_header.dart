import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _showAccountDialog(context),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(LucideIcons.user, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back,',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            Text(
              'Alex Morgan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(),
        _NotificationButton(),
      ],
    );
  }

  void _showAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Account Details'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 30, backgroundColor: AppColors.primary, child: Icon(LucideIcons.user, color: Colors.white)),
            SizedBox(height: 16),
            Text('Alex Morgan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('alex.morgan@railpulse.ai', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showNotifications(context),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(LucideIcons.bell, size: 20, color: AppColors.textPrimary),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No new alerts. Your network is clear!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
