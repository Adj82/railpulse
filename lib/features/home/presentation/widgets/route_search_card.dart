import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:railpulse/core/navigation/navigation_bloc.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/features/home/presentation/bloc/search_bloc.dart';

class RouteSearchCard extends StatefulWidget {
  const RouteSearchCard({super.key});

  @override
  State<RouteSearchCard> createState() => _RouteSearchCardState();
}

class _RouteSearchCardState extends State<RouteSearchCard> {
  String _origin = 'New Delhi (NDLS)';
  String _destination = 'Lucknow NR';

  final List<String> _stations = [
    'New Delhi (NDLS)',
    'Lucknow NR',
    'Mumbai Central',
    'Chennai Central',
    'Kolkata Howrah',
    'Bangalore City',
    'Hyderabad Deccan',
    'Pune Jn',
  ];

  void _showStationPicker(bool isOrigin) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isOrigin ? 'Select Origin' : 'Select Destination',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _stations.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_stations[index]),
                  onTap: () {
                    setState(() {
                      if (isOrigin)
                        _origin = _stations[index];
                      else
                        _destination = _stations[index];
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchSuccess) {
          // Switch tab to Map (index 1) in the BLoC
          context.read<NavigationBloc>().add(const NavigationTabChanged(1));
          // Physically move to the map route
          context.go('/map');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildStationTile(true),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Expanded(child: Divider(color: Colors.black12)),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.repeat,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const Expanded(child: Divider(color: Colors.black12)),
                ],
              ),
            ),
            _buildStationTile(false),
            const SizedBox(height: 24),
            _buildSearchButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStationTile(bool isOrigin) {
    return InkWell(
      onTap: () => _showStationPicker(isOrigin),
      child: Row(
        children: [
          Icon(
            isOrigin ? LucideIcons.mapPin : LucideIcons.navigation2,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isOrigin ? 'From' : 'To',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                isOrigin ? _origin : _destination,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              context.read<SearchBloc>().add(
                PerformSearch(from: _origin, to: _destination),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: state is SearchLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'SEARCH TRAINS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
