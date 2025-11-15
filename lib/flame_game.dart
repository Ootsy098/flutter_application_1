import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyFirstFlameGame extends FlameGame {
  MyFirstFlameGame({super.children});

  @override
  Color backgroundColor() {
    return Colors.orange;
  }
}
