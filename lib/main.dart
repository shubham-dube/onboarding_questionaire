import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/screens/onboarding_flow_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '8club',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const OnboardingFlowScreen(),
    );
  }
}