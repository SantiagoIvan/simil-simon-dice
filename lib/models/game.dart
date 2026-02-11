import 'game_element.dart';

class Game {
  final int playerId;

  int round;
  bool gameEnded;
  int score;
  int speedRate;
  bool playerTurn;

  /// Elementos disponibles para el juego (botones en pantalla)
  final List<GameElement> elements;

  /// Secuencia correcta que debe reproducir el jugador
  List<int> targetSequence;

  /// Secuencia ingresada por el jugador en la ronda actual
  List<int> playerSequence;

  Game({
    required this.playerId,
    required this.elements,
    this.round = 1,
    this.gameEnded = false,
    this.score = 0,
    this.speedRate = 1000,
    this.playerTurn = false,
    List<int>? targetSequence,
    List<int>? playerSequence,
  }) : targetSequence = targetSequence ?? [],
       playerSequence = playerSequence ?? [];

  void reset() {
    round = 1;
    gameEnded = false;
    score = 0;
    speedRate = 1000;
    playerTurn = false;
    targetSequence = [];
    playerSequence = [];
  }

  bool validateSequence() {
    for (var i = 0; i < targetSequence.length; i++) {
      if (targetSequence[i] != playerSequence[i]) {
        return false;
      }
    }
    return true;
  }
}
