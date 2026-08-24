import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/shared/widgets/glass_card.dart';

class QuickServicesGrid extends StatelessWidget {
  const QuickServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {'icon': LucideIcons.car, 'label': 'Last Mile Cab'},
      {'icon': LucideIcons.parkingSquare, 'label': 'Live Parking'},
      {'icon': LucideIcons.utensilsCrossed, 'label': 'Food in Train'},
      {'icon': LucideIcons.map, 'label': 'Platform Finder'},
      {'icon': LucideIcons.qrCode, 'label': 'QR Ticket'},
      {'icon': LucideIcons.mapPin, 'label': 'System Map'},
      {'icon': LucideIcons.bellRing, 'label': 'Dest. Alert'},
      {'icon': LucideIcons.layoutGrid, 'label': 'Coach Pos.'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return _ServiceButton(
          icon: services[index]['icon'],
          label: services[index]['label'],
        );
      },
    );
  }
}

class _ServiceButton extends StatefulWidget {
  final IconData icon;
  final String label;

  const _ServiceButton({required this.icon, required this.label});

  @override
  State<_ServiceButton> createState() => _ServiceButtonState();
}

class _ServiceButtonState extends State<_ServiceButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: GlassCard(
          padding: EdgeInsets.zero,
          borderRadius: 16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: AppColors.primaryCyan, size: 24),
              const SizedBox(height: 8),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
