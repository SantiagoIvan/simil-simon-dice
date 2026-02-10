import 'package:flutter/material.dart';
import 'package:simon_game/models/game_element.dart';
import '../../models/game.dart';

class GameScreen extends StatefulWidget {
  final Game game;

  const GameScreen({super.key, required this.game});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTitle(theme),
            _buildScore(theme),
            const SizedBox(height: 16),

            // 🔑 CLAVE: limitar altura del GridView
            Expanded(child: Center(child: _buildGameGrid())),
          ],
        ),
      ),
    );
  }

  Widget _buildScore(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: Text(
          'Score: ${widget.game.score}',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(
          widget.game.playerTurn ? 'Tu turno' : '¡Mirá!',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: theme.colorScheme.onSurface.withAlpha(180),
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(GameElement element) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: _onElementPressed(element)
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Image.asset(element.imageAsset, fit: BoxFit.contain),
        ),
      ),
    );
  }

  int _calculateColumns(int total) {
    if (total <= 4) return 2;
    if (total <= 6) return 3;
    return 4; // tablet landscape-friendly
  }

  Widget _buildGameGrid() {
    final elements = widget.game.elements;
    final int crossAxisCount = _calculateColumns(elements.length);

    return GridView.builder(
      shrinkWrap: true, // 🔑 clave
      physics: const NeverScrollableScrollPhysics(), // 🔑 clave
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: elements.length,
      itemBuilder: (context, index) {
        return _buildGameCard(elements[index]);
      },
    );
  }
}
