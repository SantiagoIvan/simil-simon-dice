import 'package:audioplayers/audioplayers.dart';
import 'package:simon_game/models/game_audio.dart';
import 'game_audio_service.dart';

class GameAudioServiceImpl implements GameAudioService {
  final AudioPlayer _player = AudioPlayer();

  @override
  Future<void> play(GameSound sound) async {
    switch (sound) {
      case GameSound.correct:
        await _player.play(AssetSource('sounds/correct.mp3'));
        break;
      case GameSound.wrong:
        await _player.play(AssetSource('sounds/wrong.mp3'));
        break;
    }
  }
}
