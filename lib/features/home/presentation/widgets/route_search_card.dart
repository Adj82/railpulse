import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/features/home/presentation/bloc/search_bloc.dart';
import 'package:railpulse/shared/widgets/glass_card.dart';

class RouteSearchCard extends StatefulWidget {
  const RouteSearchCard({super.key});

  @override
  State<RouteSearchCard> createState() => _RouteSearchCardState();
}

class _RouteSearchCardState extends State<RouteSearchCard> {
  bool _isSwapped = false;
  String _date = 'Today';
  String _class = 'All';

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchSuccess) {
          context.go('/map');
        }
      },
      child: GlassCard(
        hasGlow: true,
        child: Column(
          children: [
            _buildStationInput(
              icon: LucideIcons.mapPin,
              hint: 'Origin Station',
              label: _isSwapped ? 'Lucknow NR' : 'New Delhi (NDLS)',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  const Expanded(child: Divider(color: Colors.black12)),
                  _SwapButton(
                    onTap: () => setState(() => _isSwapped = !_isSwapped),
                    isSwapped: _isSwapped,
                  ),
                  const Expanded(child: Divider(color: Colors.black12)),
                ],
              ),
            ),
            _buildStationInput(
              icon: LucideIcons.navigation2,
              hint: 'Destination Station',
              label: _isSwapped ? 'New Delhi (NDLS)' : 'Lucknow NR',
            ),
            const SizedBox(height: 20),
            _buildChipsSection(
              title: 'Journey Date',
              options: ['Today', 'Tomorrow'],
              selected: _date,
              onSelected: (val) => setState(() => _date = val),
            ),
            const SizedBox(height: 15),
            _buildChipsSection(
              title: 'Train Class',
              options: ['All', 'Vande Bharat', 'RapidX', 'Express'],
              selected: _class,
              onSelected: (val) => setState(() => _class = val),
            ),
            const SizedBox(height: 25),
            _buildSearchButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStationInput({required IconData icon, required String hint, required String label}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.softPurple, size: 20),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hint, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildChipsSection({
    required String title,
    required List<String> options,
    required String selected,
    required Function(String) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((opt) {
              final isSel = selected == opt;
              return GestureDetector(
                onTap: () => onSelected(opt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.softPurple.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSel ? AppColors.softPurple : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      color: isSel ? AppColors.softPurple : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<SearchBloc>().add(PerformSearch(
              from: _isSwapped ? 'Lucknow NR' : 'New Delhi (NDLS)',
              to: _isSwapped ? 'New Delhi (NDLS)' : 'Lucknow NR',
            ));
          },
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.softPurple, AppColors.softPink],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.softPurple.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: state is SearchLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text(
                      'Search Smart Trains & Dynamic ETA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _SwapButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSwapped;

  const _SwapButton({required this.onTap, required this.isSwapped});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: isSwapped ? math.pi : 0),
      duration: const Duration(milliseconds: 300),
      builder: (context, angle, child) {
        return Transform.rotate(
          angle: angle,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.softPurple.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.softPurple.withOpacity(0.3)),
              ),
              child: const Icon(LucideIcons.repeat, color: AppColors.softPurple, size: 18),
            ),
          ),
        );
      },
    );
  }
}
