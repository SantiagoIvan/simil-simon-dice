import 'package:flutter/material.dart';
import 'package:simon_game/models/game_element.dart';
import 'package:simon_game/screens/menu/main_menu_screen.dart';
import 'package:simon_game/services/audio/audio_service.dart';
import '../../models/game.dart';
import '../../services/game_engine.dart';
import 'package:vibration/vibration.dart';

class GameScreen extends StatefulWidget {
  final Game game;
  final AudioService _audioService = AudioService();

  GameScreen({super.key, required this.game});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final GameEngine _engine = GameEngine();
  int? _highlightedIndex;

  late AnimationController _titleController;
  late Animation<double> _titleScale;

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _titleScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );

    _titleController.repeat(reverse: true); // 🔁 LOOP INFINITO

    _startGame();
  }

  Future<void> _startGame() async {
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
      final element = widget.game.elements[index];

      setState(() {
        _highlightedIndex = index;
      });

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

  void _onElementPressed(GameElement element) async {
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

      await _playSequence();
    }

    setState(() {});
  }

  void _onGameOver() async {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    await _triggerGameOverVibration();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SizedBox(
          width: screenWidth * 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Has perdido!',
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
  void dispose() {
    _titleController.dispose();
    super.dispose();
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
            Expanded(child: Center(child: _buildGameGrid())),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: ScaleTransition(
          scale: _titleScale,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: Text(
              widget.game.playerTurn ? 'Tu turno' : '¡Mirá la secuencia!',
              key: ValueKey(widget.game.playerTurn),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: theme.colorScheme.onSurface.withAlpha(180),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScore(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        'Score: ${widget.game.score}',
        style: theme.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.bold,
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
          clipBehavior: Clip.antiAlias,
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
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: isHighlighted ? 0.9 : 1.0,
                child: Image.asset(element.imageAsset, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _calculateColumns(int total) {
    if (total <= 4) return 2;
    if (total <= 6) return 3;
    return 4;
  }

  Widget _buildGameGrid() {
    final elements = widget.game.elements;
    final int crossAxisCount = _calculateColumns(elements.length);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: elements.length,
      itemBuilder: (context, index) => _buildGameCard(elements[index], index),
    );
  }

  Future<void> _triggerGameOverVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [0, 80, 40, 80]);
    }
  }
}
