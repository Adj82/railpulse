import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/core/services/train_service.dart';
import 'package:railpulse/features/map/presentation/widgets/performance_overlay.dart'
    as railpulse;
import 'package:railpulse/features/tracking/presentation/bloc/tracking_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  bool _followTrain = true;
  bool _isMapReady = false;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          final telemetry = state is TrackingLoaded ? state.telemetry : null;

          if (_isMapReady && _followTrain && telemetry != null) {
            _mapController.move(telemetry.position, _mapController.camera.zoom);
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: const LatLng(25.5, 82.4),
                  initialZoom: 5.0,
                  onMapReady: () => setState(() => _isMapReady = true),
                  onPositionChanged: (pos, hasGesture) {
                    if (hasGesture && _followTrain) {
                      setState(() => _followTrain = false);
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.railpulse.app',
                  ),
                  if (telemetry != null) ...[
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: telemetry.routePoints,
                          color: AppColors.primary.withOpacity(0.4),
                          strokeWidth: 5,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        // Station Markers with Congestion Tooltips
                        ...telemetry.routePoints.asMap().entries.map(
                          (e) => Marker(
                            point: e.value,
                            width: 14,
                            height: 14,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.secondary,
                                  width: 2.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Live Train Marker
                        Marker(
                          point: telemetry.position,
                          width: 90,
                          height: 90,
                          child: _LiveTrainMarker(
                            signal: telemetry.signalStatus,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              _buildOverlayUI(telemetry),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverlayUI(dynamic telemetry) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildNetworkStats(),
            const Spacer(),
            if (telemetry != null) _buildLiveStatusCard(telemetry),
            const SizedBox(height: 20),
            _buildMapControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: 'Net Load', val: '74%'),
          _Stat(label: 'Avg Delay', val: '12m'),
          _Stat(label: 'Active', val: '1.4k'),
        ],
      ),
    );
  }

  Widget _buildLiveStatusCard(dynamic telemetry) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 30),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      telemetry.trainName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Section: Howrah → New Delhi',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '+${telemetry.delayMinutes}m',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniStat(
                icon: Icons.speed,
                val: '${telemetry.speed.toInt()} km/h',
              ),
              _MiniStat(icon: Icons.timer_outlined, val: 'ETA: 21:20'),
              _MiniStat(icon: Icons.route_outlined, val: 'Buff: 8m'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        children: [
          _MapButton(
            icon: Icons.my_location,
            isSelected: _followTrain,
            onTap: () => setState(() => _followTrain = true),
          ),
          const SizedBox(height: 12),
          _MapButton(
            icon: Icons.analytics_outlined,
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const railpulse.PerformanceOverlay(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, val;
  const _Stat({required this.label, required this.val});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String val;
  const _MiniStat({required this.icon, required this.val});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          val,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _LiveTrainMarker extends StatelessWidget {
  final SignalAspect signal;
  const _LiveTrainMarker({required this.signal});

  @override
  Widget build(BuildContext context) {
    Color signalColor = AppColors.success;
    if (signal == SignalAspect.yellow) signalColor = AppColors.warning;
    if (signal == SignalAspect.red) signalColor = AppColors.error;

    return Stack(
      alignment: Alignment.center,
      children: [
        _RippleEffect(color: signalColor),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.train, color: Colors.white, size: 24),
        ),
      ],
    );
  }
}

class _RippleEffect extends StatefulWidget {
  final Color color;
  const _RippleEffect({required this.color});
  @override
  State<_RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<_RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 2.5).animate(_controller),
      child: FadeTransition(
        opacity: Tween(begin: 0.8, end: 0.0).animate(_controller),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  const _MapButton({
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}
