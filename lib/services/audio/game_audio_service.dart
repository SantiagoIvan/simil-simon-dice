import 'package:simon_game/models/game_audio.dart';

abstract class GameAudioService {
  Future<void> play(GameSound sound);
}
