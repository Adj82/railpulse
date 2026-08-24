import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/shared/widgets/glass_card.dart';

class StationFacilityExplorer extends StatefulWidget {
  const StationFacilityExplorer({super.key});

  @override
  State<StationFacilityExplorer> createState() => _StationFacilityExplorerState();
}

class _StationFacilityExplorerState extends State<StationFacilityExplorer> {
  String _selectedStation = 'Ghaziabad RapidX';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStationSelector(),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 1.4,
          children: [
            _FacilityCard(
              icon: LucideIcons.arrowUpCircle,
              label: 'Lifts & Escalators',
              status: 'Operational',
              statusColor: AppColors.neonEmerald,
            ),
            _FacilityCard(
              icon: LucideIcons.parkingCircle,
              label: 'Live Parking',
              status: '42/150 Available',
              statusColor: AppColors.primaryCyan,
            ),
            _FacilityCard(
              icon: LucideIcons.shieldCheck,
              label: 'PSD Safety',
              status: 'Secure',
              statusColor: AppColors.neonEmerald,
            ),
            _FacilityCard(
              icon: LucideIcons.sofa,
              label: 'Premium Lounge',
              status: 'Access Granted',
              statusColor: AppColors.sunsetGold,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStationSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStation,
          dropdownColor: AppColors.backgroundSurface,
          icon: const Icon(LucideIcons.chevronDown, color: AppColors.primaryCyan),
          items: ['Ghaziabad RapidX', 'Sarai Kale Khan', 'Duhai Depot']
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: const TextStyle(color: AppColors.textPrimary)),
                  ))
              .toList(),
          onChanged: (val) => setState(() => _selectedStation = val!),
        ),
      ),
    );
  }
}

class _FacilityCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String status;
  final Color statusColor;

  const _FacilityCard({
    required this.icon,
    required this.label,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(15),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
              ),
              const SizedBox(height: 2),
              Text(
                status,
                style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
