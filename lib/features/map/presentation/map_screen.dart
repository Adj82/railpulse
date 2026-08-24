import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:railpulse/core/theme/app_colors.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(28.6139, 77.2090), // New Delhi
              initialZoom: 11.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.railpulse.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(28.6139, 77.2090),
                    width: 80,
                    height: 80,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.softPurple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('NDLS', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const Icon(Icons.location_on, color: AppColors.softPurple, size: 30),
                      ],
                    ),
                  ),
                  Marker(
                    point: LatLng(28.6675, 77.4497), // Ghaziabad
                    width: 80,
                    height: 80,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.softPink,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('GZB', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const Icon(Icons.location_on, color: AppColors.softPink, size: 30),
                      ],
                    ),
                  ),
                ],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [
                      LatLng(28.6139, 77.2090),
                      LatLng(28.6675, 77.4497),
                    ],
                    color: AppColors.softPurple,
                    strokeWidth: 4,
                  ),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: AppColors.textSecondary),
                        SizedBox(width: 10),
                        const Text('Search station or route...', style: TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
