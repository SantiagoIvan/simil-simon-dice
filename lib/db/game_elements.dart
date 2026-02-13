import 'package:flutter/material.dart';

import '../models/game_element.dart';

const List<GameElement> defaultGameElements = [
  GameElement(
    id: 0,
    label: 'Sol',
    imageAsset: 'assets/images/oiia.jpg',
    color: Colors.blue,
    audioAsset: 'assets/audio/blue.wav',
  ),
  GameElement(
    id: 1,
    label: 'Luna',
    imageAsset: 'assets/images/oiia.jpg',
    color: Colors.red,
    audioAsset: 'assets/audio/red.wav',
  ),
  GameElement(
    id: 2,
    label: 'Estrella',
    imageAsset: 'assets/images/oiia.jpg',
    color: Colors.yellow,
    audioAsset: 'assets/audio/yellow.wav',
  ),
  GameElement(
    id: 3,
    label: 'Nube',
    imageAsset: 'assets/images/oiia.jpg',
    color: Colors.green,
    audioAsset: 'assets/audio/green.wav',
  ),
  GameElement(
    id: 4,
    label: 'test',
    imageAsset: 'assets/images/oiia.jpg',
    color: Colors.orange,
    audioAsset: 'assets/audio/orange.wav',
  ),
];
