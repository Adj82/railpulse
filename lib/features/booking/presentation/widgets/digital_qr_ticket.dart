import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:railpulse/shared/widgets/glass_card.dart';

class DigitalQrTicket extends StatefulWidget {
  const DigitalQrTicket({super.key});

  @override
  State<DigitalQrTicket> createState() => _DigitalQrTicketState();
}

class _DigitalQrTicketState extends State<DigitalQrTicket> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final ticket = state is BookingLoaded ? state.lastTicket : null;
        
        return Stack(
          children: [
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return Container(
                  height: 420,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [
                        _shimmerController.value - 0.3,
                        _shimmerController.value,
                        _shimmerController.value + 0.3,
                      ],
                      colors: [
                        Colors.transparent,
                        AppColors.softPurple.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
            GlassCard(
              borderRadius: 30,
              padding: const EdgeInsets.all(25),
              hasGlow: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NAMO BHARAT',
                            style: TextStyle(
                              color: AppColors.softPurple,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'RAPIDX SYSTEM',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
                          ),
                        ],
                      ),
                      _buildCoachBadge(ticket?.coachClass ?? 'BUSINESS CLASS'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildQrSection(),
                  const SizedBox(height: 15),
                  Text(
                    ticket != null ? 'ID: ${ticket.id.substring(0, 8).toUpperCase()}' : 'SCAN AT GATE',
                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, letterSpacing: 2),
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Colors.black12, thickness: 1),
                  const SizedBox(height: 20),
                  _buildTripInfo(ticket?.from ?? 'GHAZIABAD', ticket?.to ?? 'DUHAI'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCoachBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.softPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.softPurple.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.softPurple,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQrSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(Icons.qr_code_2, size: 180, color: Colors.black),
    );
  }

  Widget _buildTripInfo(String from, String to) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('VALID FROM', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
            Text(from, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const Icon(Icons.arrow_forward, color: AppColors.softPurple),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('VALID TO', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
            Text(to, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ],
    );
  }
}
