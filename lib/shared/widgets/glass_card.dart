import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:railpulse/core/theme/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final bool hasGlow;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.all(20),
    this.hasGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: hasGlow
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.softPurple.withOpacity(0.15),
                  blurRadius: 25,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
