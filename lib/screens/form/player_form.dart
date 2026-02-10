import 'package:flutter/material.dart';
import 'package:simon_game/repository/player_repository.dart';
import 'package:simon_game/services/save_player/save_player.dart';
import '../../models/player.dart';
import '../../services/save_player/excel_service.dart';
import '../menu/main_menu_screen.dart';
import '../game/game.dart';
import '../../db/game_elements.dart';
import '../../models/game.dart';

class PlayerFormScreen extends StatefulWidget {
  final SavePlayerService savePlayerService;

  const PlayerFormScreen({super.key, required this.savePlayerService});

  @override
  State<PlayerFormScreen> createState() => _PlayerFormScreenState();
}

class _PlayerFormScreenState extends State<PlayerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _startGame() async {
    if (!_formKey.currentState!.validate()) return;

    final player = Player(
      id: PlayerRepository.getId(),
      name: _nameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
    );

    await widget.savePlayerService.save(player);

    if (!mounted) return;

    final game = Game(playerId: 1, elements: defaultGameElements);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GameScreen(game: game)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Datos del jugador')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _field('Nombre', _nameCtrl),
              _field('Apellido', _lastNameCtrl),
              _field('Celular', _phoneCtrl, keyboard: TextInputType.phone),
              _field('Email', _emailCtrl, keyboard: TextInputType.emailAddress),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainMenuScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Volver',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _startGame,
                        child: const Text('¡Comenzar ya!'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(labelText: label),
      validator: (value) =>
          value == null || value.isEmpty ? 'Campo obligatorio' : null,
    );
  }
}
