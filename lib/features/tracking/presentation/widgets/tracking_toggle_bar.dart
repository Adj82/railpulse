import 'package:flutter/material.dart';
import 'package:railpulse/core/theme/app_colors.dart';

class TrackingToggleBar extends StatefulWidget {
  const TrackingToggleBar({super.key});

  @override
  State<TrackingToggleBar> createState() => _TrackingToggleBarState();
}

class _TrackingToggleBarState extends State<TrackingToggleBar> {
  int _selectedIndex = 0;
  final List<String> _options = ['Timeline', 'Speed Graph', 'Live Map'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: List.generate(_options.length, (index) {
          final isSelected = _selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryCyan.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _options[index],
                    style: TextStyle(
                      color: isSelected ? AppColors.primaryCyan : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
