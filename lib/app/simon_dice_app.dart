import 'package:flutter/material.dart';
import 'package:simon_game/theme/app_theme.dart';
import '../screens/splash/splash_screen.dart';
import '../config/app_config.dart';

class SimonDiceApp extends StatelessWidget {
  const SimonDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
