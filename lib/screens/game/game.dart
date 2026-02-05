import 'package:flutter/material.dart';
import '../../config/app_config.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Text(
          AppConfig.appName,
          style: theme.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
