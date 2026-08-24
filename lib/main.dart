import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:railpulse/core/navigation/app_router.dart';
import 'package:railpulse/core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: RailPulseApp(),
    ),
  );
}

class RailPulseApp extends StatelessWidget {
  const RailPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RailPulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
