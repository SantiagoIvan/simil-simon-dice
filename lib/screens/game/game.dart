import 'package:flutter/material.dart';
import 'package:simon_game/models/game_element.dart';
import 'package:simon_game/screens/menu/main_menu_screen.dart';
import '../../models/game.dart';
import '../../services/game_engine.dart';

class GameScreen extends StatefulWidget {
  final Game game;

  const GameScreen({super.key, required this.game});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameEngine _engine = GameEngine();
  int? _highlightedIndex;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() async {
    _engine.generateNextStep(widget.game);
    await _playSequence();

    setState(() {
      widget.game.playerTurn = true;
    });
  }

  void _restart() {
    widget.game.reset();
    _startGame();
  }

  Future<void> _playSequence() async {
    setState(() {
      widget.game.playerTurn = false;
    });

    for (int index in widget.game.targetSequence) {
      setState(() {
        _highlightedIndex = index;
      });

      // 🔊 reproducir sonido acá si querés

      await Future.delayed(Duration(milliseconds: widget.game.speedRate));

      setState(() {
        _highlightedIndex = null;
      });

      await Future.delayed(const Duration(milliseconds: 250));
    }

    setState(() {
      widget.game.playerTurn = true;
    });
  }

  void _onElementPressed(GameElement element) {
    if (!widget.game.playerTurn) return;

    final isValid = _engine.validatePlayerInput(widget.game, element.id);

    if (!isValid) {
      _onGameOver();
      return;
    }

    if (_engine.isRoundCompleted(widget.game)) {
      widget.game.playerTurn = false;

      _engine.nextRound(widget.game);
      _engine.generateNextStep(widget.game);

      _playSequence().then((_) {
        setState(() {
          widget.game.playerTurn = true;
        });
      });
    }

    setState(() {});
  }

  void _onGameOver() {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SizedBox(
          width: screenWidth * 0.5, // 🔑 50% del ancho
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'GAME OVER',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Score final: ${widget.game.score}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _restart();
                    },
                    child: const Text('REINTENTAR'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: theme.colorScheme.onSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const MainMenuScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text('MENÚ PRINCIPAL'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
          widget.game.playerTurn ? 'Tu turno' : '¡Mirá la secuencia!',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: theme.colorScheme.onSurface.withAlpha(180),
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(GameElement element, int index) {
    final bool isHighlighted = _highlightedIndex == index;

    return AnimatedScale(
      scale: isHighlighted ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isHighlighted
              ? [
                  BoxShadow(
                    color: element.color.withAlpha(150),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ]
              : [],
        ),
        child: Card(
          elevation: isHighlighted ? 12 : 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.game.playerTurn
                ? () => _onElementPressed(element)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(element.imageAsset, fit: BoxFit.contain),
            ),
          ),
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
        return _buildGameCard(elements[index], index);
      },
    );
  }
}
