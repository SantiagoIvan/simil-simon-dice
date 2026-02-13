import 'dart:async';

import 'package:just_audio/just_audio.dart';

class AudioService {
  static final Map<String, AudioPlayer> _players = {};

  static Future<void> preloadTones(Iterable<String> assetPaths) async {
    for (final assetPath in assetPaths.toSet()) {
      final player = _players.putIfAbsent(assetPath, AudioPlayer.new);
      if (player.audioSource == null) {
        await player.setAsset(assetPath);
      }
    }
  }

  static Future<void> playTone(String assetPath) async {
    final player = _players.putIfAbsent(assetPath, AudioPlayer.new);

    if (player.audioSource == null) {
      await player.setAsset(assetPath);
    }

    await player.seek(Duration.zero);
    unawaited(player.play());
  }

  static Future<void> stopTone(String assetPath) async {
    final player = _players[assetPath];
    if (player == null) return;
    await player.stop();
  }

  static Future<void> dispose() async {
    for (final player in _players.values) {
      await player.dispose();
    }
    _players.clear();
  }
}
