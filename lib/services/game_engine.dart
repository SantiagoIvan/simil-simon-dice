import 'dart:math';
import '../models/game.dart';

class GameEngine {
  final Random _random = Random();

  /// Agrega un nuevo elemento a la secuencia
  void generateNextStep(Game game) {
    final randomElement = game.elements[_random.nextInt(game.elements.length)];

    game.targetSequence.add(randomElement.id);
    print(game.targetSequence);
  }

  /// Valida el input del jugador
  /// Retorna:
  /// - true  -> input correcto
  /// - false -> error (game over)
  bool validatePlayerInput(Game game, int elementId) {
    game.playerSequence.add(elementId);

    final int index = game.playerSequence.length - 1;

    if (game.playerSequence[index] != game.targetSequence[index]) {
      print(
        "comparing " +
            game.playerSequence[index].toString() +
            " with " +
            game.targetSequence[index].toString(),
      );
      game.gameEnded = true;
      return false;
    }

    return true;
  }

  /// Devuelve true si la ronda fue completada
  bool isRoundCompleted(Game game) {
    return game.playerSequence.length == game.targetSequence.length;
  }

  /// Avanza a la siguiente ronda
  void nextRound(Game game) {
    game.round++;
    game.score += 10 * game.round;
    game.playerSequence.clear();

    // aumentar dificultad
    game.speedRate = (game.speedRate * 0.9).toInt();
  }
}
