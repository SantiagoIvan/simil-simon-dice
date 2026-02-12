import 'package:just_audio/just_audio.dart';

class AudioService {
  Future<void> playTone(String assetPath) async {
    final player = AudioPlayer();
    await player.setAsset('$assetPath');
    await player.play();
    await player.dispose();
  }
}
