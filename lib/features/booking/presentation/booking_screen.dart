import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:railpulse/features/booking/presentation/widgets/digital_qr_ticket.dart';
import 'package:railpulse/features/booking/presentation/widgets/station_facility_explorer.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.paleBlue,
              Colors.white,
              AppColors.lightPink,
            ],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              if (state is BookingLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              double balance = 0.0;
              if (state is BookingLoaded) {
                balance = state.balance;
              }

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  Text(
                    'Digital Wallet',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 25),
                  const DigitalQrTicket(),
                  const SizedBox(height: 30),
                  _buildNcmcCard(context, balance),
                  const SizedBox(height: 40),
                  const Text(
                    'Station Facilities',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const StationFacilityExplorer(),
                  const SizedBox(height: 100),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNcmcCard(BuildContext context, double balance) {
    return GestureDetector(
      onTap: () => _showFareBreakdown(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF334155)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'NCMC Balance',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                Text(
                  '₹ ${balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primaryCyan,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                context.read<BookingBloc>().add(const TopUpBalance(500));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Top-up successful! ₹500 added.'))
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Top Up', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFareBreakdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Booking (GZB -> DUHAI)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            _fareRow('Base Fare', '₹ 40.00'),
            _fareRow('Business Class Upgrade', '₹ 60.00'),
            const Divider(color: Colors.black12, height: 30),
            _fareRow('Total Amount', '₹ 100.00', isTotal: true),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.softPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  context.read<BookingBloc>().add(const BookTicket(
                    from: 'GHAZIABAD',
                    to: 'DUHAI',
                    fare: 100.0,
                    coachClass: 'BUSINESS CLASS',
                  ));
                  Navigator.pop(context);
                },
                child: const Text('Confirm & Pay', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fareRow(String label, String val, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isTotal ? Colors.black : AppColors.textSecondary)),
          Text(
            val,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? AppColors.softPurple : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
