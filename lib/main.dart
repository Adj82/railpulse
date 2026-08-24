import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:railpulse/core/navigation/app_router.dart';
import 'package:railpulse/core/theme/app_theme.dart';
import 'package:railpulse/core/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: RailPulseApp()));
}

class RailPulseApp extends StatefulWidget {
  const RailPulseApp({super.key});

  @override
  State<RailPulseApp> createState() => _RailPulseAppState();
}

class _RailPulseAppState extends State<RailPulseApp> {
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: RailPulseSplashScreen(
          onInitializationComplete: () => setState(() => _initialized = true),
        ),
      );
    }

    return MaterialApp.router(
      title: 'RailPulse AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
