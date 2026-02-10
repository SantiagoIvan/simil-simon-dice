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
  final List<int> targetSequence;

  /// Secuencia ingresada por el jugador en la ronda actual
  final List<int> playerSequence;

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
}
