import 'package:flutter/material.dart';

class GameElement {
  final int id;
  final String label;
  final String imageAsset;
  final Color color;
  final String audioAsset;

  const GameElement({
    required this.id,
    required this.label,
    required this.imageAsset,
    required this.color,
    required this.audioAsset,
  });
}
