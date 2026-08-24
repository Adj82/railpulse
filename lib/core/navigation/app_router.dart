import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:railpulse/core/navigation/navigation_shell.dart';
import 'package:railpulse/features/home/presentation/home_screen.dart';
import 'package:railpulse/features/map/presentation/map_screen.dart';
import 'package:railpulse/features/booking/presentation/booking_screen.dart';
import 'package:railpulse/features/insights/presentation/insights_screen.dart';
import 'package:railpulse/features/tracking/presentation/train_tracking_screen.dart';
import 'package:railpulse/features/eta_tracking/presentation/screens/train_input_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return NavigationShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/map',
          builder: (context, state) => const MapScreen(),
        ),
        GoRoute(
          path: '/booking',
          builder: (context, state) => const BookingScreen(),
        ),
        GoRoute(
          path: '/insights',
          builder: (context, state) => const InsightsScreen(),
        ),
        GoRoute(
          path: '/tracking',
          builder: (context, state) => const TrainTrackingScreen(),
        ),
        GoRoute(
          path: '/tracker',
          builder: (context, state) => const TrainInputScreen(),
        ),
      ],
    ),
  ],
);
